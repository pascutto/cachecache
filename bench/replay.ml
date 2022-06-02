type span = Mtime.span

let span_t = Repr.map Repr.float (fun _ -> assert false) Mtime.Span.to_s

type stats = {
  mutable add : int;
  mutable mem : int;
  mutable find : int;
  mutable hit : int;
  mutable miss : int;
  mutable add_span : float;
  mutable mem_span : float;
  mutable find_span : float;
  mutable total_runtime_span : float;
}
[@@deriving repr ~pp]

module K = struct
  include String

  let hash = Hashtbl.hash
end

let pr_bench test_name metrics =
  Format.printf {|{"results": [{"name": "%s", "metrics": [%s]}]}@.|} test_name
    metrics

let metrics metric_name value =
  Printf.sprintf {|{"name": "%s", "value": %f, "units": "ms"}|} metric_name
    value

let mtime s counter (f : unit -> unit) =
  let t = Mtime_clock.count counter in
  f ();
  let t =
    Mtime.Span.to_ms (Mtime.Span.abs_diff (Mtime_clock.count counter) t)
  in
  s.total_runtime_span <- s.total_runtime_span +. t;
  t

module Make (Cache : Cachecache.S.Cache with type key = K.t) = struct
  let bench cap =
    let stats =
      {
        add = 0;
        mem = 0;
        find = 0;
        hit = 0;
        miss = 0;
        add_span = 0.;
        mem_span = 0.;
        find_span = 0.;
        total_runtime_span = 0.;
      }
    in
    let open Lru_trace_definition in
    let _, { instance_count }, seq = open_reader "./trace/lru.trace" in
    let caches = List.init instance_count (fun _ -> Cache.v cap) in
    let counter = Mtime_clock.counter () in
    Seq.iter
      (fun { instance_id; op } ->
        let cache = List.nth caches instance_id in
        match op with
        | Add k ->
            stats.add_span <-
              stats.add_span +. mtime stats counter (Cache.replace cache k);
            stats.add <- stats.add + 1
        | Find k ->
            stats.find_span <-
              stats.find_span
              +. mtime stats counter (fun _ -> ignore (Cache.find_opt cache k));
            stats.find <- stats.find + 1
        | Mem k ->
            let b = Cache.mem cache k in
            stats.mem_span <-
              stats.mem_span +. mtime stats counter (fun _ -> ignore b);
            if b then stats.hit <- stats.hit + 1
            else stats.miss <- stats.miss + 1;
            stats.mem <- stats.mem + 1
        | _ -> assert false)
      seq;
    (* pr_bench name (metrics "add" stats.add_span);
       pr_bench name (metrics "find" stats.find_span);

       pr_bench name (metrics "total_runtime" stats.total_runtime_span); *)
    stats
end

include Cachecache.Lru.Make (K)
module Lru = Cachecache.Lru.Make (K)
module Lfu = Cachecache.Lfu.Make (K)
module Bench_lru = Make (Lru)
module Bench_lfu = Make (Lfu)

let () =
  let t = [| 1000; 10000; 100000 |] in
  for _ = 0 to 2 do
    for i = 0 to Array.length t - 1 do
      Fmt.pr "cap = %d\n" t.(i);
      let lru_stats = Bench_lru.bench t.(i) in
      let lfu_stats = Bench_lfu.bench t.(i) in
      pr_bench "add"
        (metrics "add/lru" lru_stats.add_span
        ^ ","
        ^ metrics "add/lfu" lfu_stats.add_span);
      pr_bench "find"
        (metrics "find/lru" lru_stats.find_span
        ^ ","
        ^ metrics "find/lfu" lfu_stats.find_span);
      pr_bench "total_runtime"
        (metrics "total_runtime/lru" lru_stats.total_runtime_span
        ^ ","
        ^ metrics "total_runtime/lfu" lfu_stats.total_runtime_span);
      let str_cap = string_of_int t.(i) in
      pr_bench "lfu" (metrics ("add/" ^ str_cap) lfu_stats.add_span);
      pr_bench "lfu" (metrics ("find/" ^ str_cap) lfu_stats.find_span);
      pr_bench "lfu"
        (metrics ("total_runtime/" ^ str_cap) lfu_stats.total_runtime_span);
      pr_bench "lru" (metrics ("add/" ^ str_cap) lru_stats.add_span);
      pr_bench "lru" (metrics ("find/" ^ str_cap) lru_stats.find_span);
      pr_bench "lru"
        (metrics ("total_runtime/" ^ str_cap) lru_stats.total_runtime_span)
    done
  done
