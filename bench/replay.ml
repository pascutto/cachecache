module K = struct
  include String

  let hash = Hashtbl.hash
end

module Lru =
  Lru.M.Make
    (K)
    (struct
      type t = unit

      let weight _ = 1
    end)

let () =
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
      | 1, Add k -> Lru.replace lru k ()
      | 1, Find k -> ignore (Lru.find_opt lru k)
      | 1, Mem k -> ignore (Lru.mem lru k)
      | _ -> ())
    seq
