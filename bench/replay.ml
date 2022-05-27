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
  let lrus = List.init instance_count (fun _ -> Lru.v 5000) in
  Seq.iter
    (fun { instance_id; op } ->
      let lru = List.nth lrus instance_id in
      match op with
      | Add k ->
          Lru.replace lru k ();
          stats.add <- stats.add + 1
      | Find k ->
          ignore (Lru.find_opt lru k : _ option);
          stats.find <- stats.find + 1
      | Mem k ->
          ignore (Lru.mem lru k : bool);
          stats.mem <- stats.mem + 1
      | _ -> ())
    seq;
  Fmt.pr "%a\n" pp_stats stats
