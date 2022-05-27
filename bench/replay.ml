type span = Mtime.span

let span_t = Repr.map Repr.float (fun _ -> assert false) Mtime.Span.to_s

type stats = {
  mutable add : int;
  mutable mem : int;
  mutable find : int;
  mutable add_span : span;
  mutable mem_span : span;
  mutable find_span : span;
}
[@@deriving repr ~pp]

module K = struct
  include String

  let hash = Hashtbl.hash
end

module Make (Cache : Cachecache.S.Cache with type key = K.t) = struct
  let bench cap =
    let stats =
      {
        add = 0;
        mem = 0;
        find = 0;
        add_span = Mtime.Span.zero;
        mem_span = Mtime.Span.zero;
        find_span = Mtime.Span.zero;
      }
    in
    let open Lru_trace_definition in
    let _, { instance_count }, seq =
      open_reader "/home/cha//Downloads/lru.trace"
    in
    let caches = List.init instance_count (fun _ -> Cache.v cap) in
    let counter = Mtime_clock.counter () in
    Seq.iter
      (fun { instance_id; op } ->
        let cache = List.nth caches instance_id in
        match op with
        | Add k ->
            let before = Mtime_clock.count counter in
            Cache.replace cache k ();
            let after = Mtime_clock.count counter in
            stats.add_span <-
              Mtime.Span.(abs_diff after before |> add stats.add_span);
            stats.add <- stats.add + 1
        | Find k ->
            let before = Mtime_clock.count counter in
            ignore (Cache.find_opt cache k : _ option);
            let after = Mtime_clock.count counter in
            stats.find_span <-
              Mtime.Span.(abs_diff after before |> add stats.find_span);
            stats.find <- stats.find + 1
        | Mem k ->
            let before = Mtime_clock.count counter in
            ignore (Cache.mem cache k : bool);
            let after = Mtime_clock.count counter in
            stats.mem_span <-
              Mtime.Span.(abs_diff after before |> add stats.mem_span);
            stats.mem <- stats.mem + 1
        | _ -> assert false)
      seq;
    Fmt.pr "%a\n" pp_stats stats
end

module Lru = Cachecache.Lru.Make (K)
module Lfu = Cachecache.Lfu.Make (K)
module Bench_lru = Make (Lru)
module Bench_lfu = Make (Lfu)

let () = Bench_lru.bench 5000
let () = Bench_lfu.bench 5000
