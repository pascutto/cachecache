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

(** Utility to simplify the management of files using the following layout:

    - Magic (Magic.t, 8 bytes)
    - Version (int32, 4 bytes)
    - Length of header (varint, >=1 byte)
    - Header (header_t, _ bytes)
    - Arbitrary long series of rows, of unspecified length, each prefixed by
      their length:
    - Length of row (varint, >=1 byte)
    - Row (row_t, _ bytes) *)

module type MAGIC = sig
  type t

  val of_string : string -> t
  val to_string : t -> string
  val pp : Format.formatter -> t -> unit
end

(** Manually defined *)
module type FILE_FORMAT = sig
  (** The latest up-to-date definition of the file format *)
  module Latest : sig
    val version : int

    type header [@@deriving repr]
    type row [@@deriving repr]
  end

  type magic

  val magic : magic

  type ('a, 'b) version_converter

  val get_version_converter :
    int -> (Latest.header, Latest.row) version_converter
  (** [get_version_converter v] is a converter that can upgrade headers and rows
      from a version [i] to [Latest.version]. It may raise [Invalid_argument] if *)
end

(** Automatically defined *)
module type S = sig
  module File_format : FILE_FORMAT

  val open_reader :
    string -> int * File_format.Latest.header * File_format.Latest.row Seq.t

  type writer

  val create : out_channel -> File_format.Latest.header -> writer
  val create_file : string -> File_format.Latest.header -> writer
  val append_row : writer -> File_format.Latest.row -> unit
  val flush : writer -> unit
  val close : writer -> unit
end

module type Trace_auto_file_format = sig
  type ('a, 'b) version_converter

  val create_version_converter :
    header_t:'header Repr.ty ->
    row_t:'row Repr.ty ->
    upgrade_header:('header -> 'latest_header) ->
    upgrade_row:('row -> 'latest_row) ->
    ('latest_header, 'latest_row) version_converter
  (** Create a value that contains everything needed to upgrade on-the-fly a
      file version to the latest version defined by the file format. *)

  module type MAGIC = MAGIC

  module Magic : MAGIC

  module type FILE_FORMAT =
    FILE_FORMAT
      with type magic := Magic.t
      with type ('a, 'b) version_converter := ('a, 'b) version_converter

  module type S =
    S
      with type File_format.magic := Magic.t
      with type ('a, 'b) File_format.version_converter :=
        ('a, 'b) version_converter

  (** Derive the IO operations from a file format. *)
  module Make (File_format : FILE_FORMAT) :
    S with module File_format = File_format
end
