(** File format of a trace listing the interactions with repr's LRU *)

module V0 = struct
  let version = 0

  type header = { instance_count : int } [@@deriving repr]

  type op = Add of string | Find of string | Mem of string | Clear
  [@@deriving repr]

  type row = { instance_id : int; op : op } [@@deriving repr]
end

module Latest = V0
include Latest

include Trace_auto_file_format.Make (struct
  module Latest = Latest

  let magic = Trace_auto_file_format.Magic.of_string "LRUtrace"

  let get_version_converter = function
    | 0 ->
        Trace_auto_file_format.create_version_converter ~header_t:V0.header_t
          ~row_t:V0.row_t ~upgrade_header:Fun.id ~upgrade_row:Fun.id
    | i ->
        let msg = Fmt.str "Unknown Raw_actions_trace version %d" i in
        failwith msg
end)
