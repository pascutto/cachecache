type stats = { mutable add : int; mutable mem : int; mutable find : int }
[@@deriving repr ~pp]

module K = struct
  include String

  let hash = Hashtbl.hash
end

module Lru = Cachecache.Lru.Make (K)

let () =
  let stats = { add = 0; mem = 0; find = 0 } in
  let open Lru_trace_definition in
  let _, { instance_count }, seq =
    open_reader "/home/cha//Downloads/lru.trace"
  in
  ignore instance_count;
  let lru = Lru.v 5000 in
  (*instane lru*)
  Seq.iter
    (fun { instance_id; op } ->
      match (instance_id, op) with
      | 1, Add k ->
          Lru.replace lru k ();
          stats.add <- stats.add + 1
      | 1, Find k ->
          ignore (Lru.find_opt lru k);
          stats.find <- stats.find + 1
      | 1, Mem k ->
          ignore (Lru.mem lru k);
          stats.mem <- stats.mem + 1
      | _ -> ())
    seq;
  Fmt.pr "%a\n" pp_stats stats
