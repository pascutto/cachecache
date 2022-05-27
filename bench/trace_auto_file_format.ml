(*****************************************************************************)
(*                                                                           *)
(* Open Source License                                                       *)
(* Copyright (c) 2021-2022 Tarides <contact@tarides.com>                     *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING   *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER       *)
(* DEALINGS IN THE SOFTWARE.                                                 *)
(*                                                                           *)
(*****************************************************************************)

include Trace_auto_file_format_intf

type ('latest_header, 'latest_row, 'header, 'row) version_converter' = {
  header_t : 'header Repr.ty;
  row_t : 'row Repr.ty;
  upgrade_header : 'header -> 'latest_header;
  upgrade_row : 'row -> 'latest_row;
}
(** Contains everything needed to read a file as if it is written using the
    lastest version. *)

(** A box containing the above record *)
type (_, _) version_converter =
  | Version_converter :
      ('latest_header, 'latest_row, 'header, 'row) version_converter'
      -> ('latest_header, 'latest_row) version_converter

let create_version_converter :
    header_t:'header Repr.ty ->
    row_t:'row Repr.ty ->
    upgrade_header:('header -> 'latest_header) ->
    upgrade_row:('row -> 'latest_row) ->
    ('latest_header, 'latest_row) version_converter =
 fun ~header_t ~row_t ~upgrade_header ~upgrade_row ->
  Version_converter { header_t; row_t; upgrade_header; upgrade_row }

module Magic : MAGIC = struct
  type t = string

  let of_string s =
    if String.length s <> 8 then
      invalid_arg "Magic.of_string, string should have 8 chars";
    s

  let to_string s = s
  let pp ppf s = Format.fprintf ppf "%s" (String.escaped s)
end

module type FILE_FORMAT =
  FILE_FORMAT
    with type magic := Magic.t
    with type ('a, 'b) version_converter := ('a, 'b) version_converter

module type S =
  S
    with type File_format.magic := Magic.t
    with type ('a, 'b) File_format.version_converter :=
      ('a, 'b) version_converter

(** Variable size integer. Very similar to what can be found in
    "repr/type_binary.ml", but working straight off channels. [Var_int.read_exn]
    reads the chars one by one from the provided [chan]. The recursion stops as
    soon as a read char has its 8th bit equal to [0]. [Var_int.write] could be
    implemented using [Repr.encode_bin int], but since [read_exn] can't be
    implemented using repr, [write] isn't either. *)
module Var_int = struct
  let chars =
    Array.init 256 (fun i -> Bytes.unsafe_to_string (Bytes.make 1 (Char.chr i)))

  let write : int -> out_channel -> unit =
    let int i k =
      let rec aux n k =
        if n >= 0 && n < 128 then k chars.(n)
        else
          let out = 128 lor (n land 127) in
          k chars.(out);
          aux (n lsr 7) k
      in
      aux i k
    in
    fun i chan -> int i (output_string chan)

  let read_exn : in_channel -> int =
   fun chan ->
    let max_bits = Sys.word_size - 1 in
    let rec aux n p =
      let () =
        if p >= max_bits then raise (failwith "Failed to decode varint")
      in
      let i = input_char chan |> Char.code in
      let n = n + ((i land 127) lsl p) in
      if i >= 0 && i < 128 then n else aux n (p + 7)
    in
    aux 0 0
end

module Make (Ff : FILE_FORMAT) = struct
  module File_format = Ff

  let decode_i32 = Repr.(decode_bin int32 |> unstage)
  let encode_i32 = Repr.(encode_bin int32 |> unstage)
  let encode_lheader = Repr.(encode_bin Ff.Latest.header_t |> unstage)
  let encode_lrow = Repr.(encode_bin Ff.Latest.row_t |> unstage)

  let read_with_prefix_exn : (string -> int ref -> 'a) -> in_channel -> 'a =
   fun decode chan ->
    (* First read the prefix *)
    let len = Var_int.read_exn chan in
    (* Then read the repr. *)
    let offset_ref = ref 0 in
    let v =
      (* This could fail if [len] is not long enough for repr (corruption) *)
      decode (really_input_string chan len) offset_ref
    in
    let () =
      if len <> !offset_ref then
        let msg =
          Fmt.str
            "A value read in the Trace was expected to take %d bytes, but it \
             took only %d."
            len !offset_ref
        in
        raise (failwith msg)
    in
    v

  let decoded_seq_of_encoded_chan_with_prefixes :
      'a Repr.ty -> in_channel -> 'a Seq.t =
   fun repr chan ->
    let decode = Repr.decode_bin repr |> Repr.unstage in
    let produce_row () =
      try
        let row = read_with_prefix_exn decode chan in
        Some (row, ())
      with End_of_file -> None
    in
    Seq.unfold produce_row ()

  let open_reader : string -> int * Ff.Latest.header * Ff.Latest.row Seq.t =
   fun path ->
    let chan = open_in_bin path in
    let len = LargeFile.in_channel_length chan in
    let () =
      if len < 12L then
        let msg = Fmt.str "File '%s' should be at least 12 byte long" path in
        raise (failwith msg)
    in

    let magic = Magic.of_string (really_input_string chan 8) in
    let () =
      if magic <> Ff.magic then
        let msg =
          Fmt.str "File '%s' has magic '%a'. Expected '%a'." path Magic.pp magic
            Magic.pp Ff.magic
        in
        raise (failwith msg)
    in

    let offset_ref = ref 0 in
    let version = decode_i32 (really_input_string chan 4) offset_ref in
    let (Version_converter vc) =
      assert (!offset_ref = 4);
      Ff.get_version_converter (Int32.to_int version)
    in

    let header =
      let decode_header = Repr.(decode_bin vc.header_t |> unstage) in
      read_with_prefix_exn decode_header chan |> vc.upgrade_header
    in
    let seq =
      decoded_seq_of_encoded_chan_with_prefixes vc.row_t chan
      |> Seq.map vc.upgrade_row
    in
    (Int32.to_int version, header, seq)

  type writer = { channel : out_channel; buffer : Buffer.t }

  let create channel header =
    let buffer = Buffer.create 0 in
    output_string channel (Magic.to_string Ff.magic);
    encode_i32 (Int32.of_int Ff.Latest.version) (output_string channel);
    encode_lheader header (Buffer.add_string buffer);
    Var_int.write (Buffer.length buffer) channel;
    output_string channel (Buffer.contents buffer);
    Buffer.clear buffer;
    { channel; buffer }

  let create_file path header = create (open_out path) header

  let append_row { channel; buffer; _ } row =
    encode_lrow row (Buffer.add_string buffer);
    Var_int.write (Buffer.length buffer) channel;
    output_string channel (Buffer.contents buffer);
    Buffer.clear buffer

  let flush { channel; _ } = flush channel
  let close { channel; _ } = close_out channel
end
