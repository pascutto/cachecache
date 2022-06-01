type span = Mtime.span

let span_t = Repr.map Repr.float (fun _ -> assert false) Mtime.Span.to_s

type stats = {
  mutable add : int;
  mutable mem : int;
  mutable find : int;
  mutable hit : int;
  mutable miss : int;
  mutable add_span : span;
  mutable mem_span : span;
  mutable find_span : span;
  mutable total_runtime_span : span;
}
[@@deriving repr ~pp]

module K = struct
  include String

  let hash = Hashtbl.hash
end

let pr_bench test_name metric_name value =
  Format.printf
    {|{"results": [{"name": "%s", "metrics": [{"name": "%s", "value": %f, "units": "ms"}]}]}@.|}
    test_name metric_name value

module Make (Cache : Cachecache.S.Cache with type key = K.t) = struct
  let bench cap =
    let stats =
      {
        add = 0;
        mem = 0;
        find = 0;
        hit = 0;
        miss = 0;
        add_span = Mtime.Span.zero;
        mem_span = Mtime.Span.zero;
        find_span = Mtime.Span.zero;
        total_runtime_span = Mtime.Span.zero;
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
            let before = Mtime_clock.count counter in
            Cache.replace cache k ();
            let after = Mtime_clock.count counter in
            stats.total_runtime_span <-
              Mtime.Span.(abs_diff after before |> add stats.total_runtime_span);
            stats.add_span <-
              Mtime.Span.(abs_diff after before |> add stats.add_span);
            stats.add <- stats.add + 1
        | Find k ->
            let before = Mtime_clock.count counter in
            ignore (Cache.find_opt cache k : _ option);
            let after = Mtime_clock.count counter in
            stats.total_runtime_span <-
              Mtime.Span.(abs_diff after before |> add stats.total_runtime_span);
            stats.find_span <-
              Mtime.Span.(abs_diff after before |> add stats.find_span);
            stats.find <- stats.find + 1
        | Mem k ->
            let before = Mtime_clock.count counter in
            let b = Cache.mem cache k in
            let after = Mtime_clock.count counter in
            stats.total_runtime_span <-
              Mtime.Span.(abs_diff after before |> add stats.total_runtime_span);
            stats.mem_span <-
              Mtime.Span.(abs_diff after before |> add stats.mem_span);
            if b then stats.hit <- stats.hit + 1
            else stats.miss <- stats.miss + 1;
            stats.mem <- stats.mem + 1
        | _ -> assert false)
      seq;
    pr_bench "add"
      (Cache.name () ^ "add_metric")
      (Mtime.Span.to_ms stats.add_span);
    pr_bench "mem"
      (Cache.name () ^ "mem_metric")
      (Mtime.Span.to_ms stats.mem_span);
    pr_bench "find"
      (Cache.name () ^ "find_metric")
      (Mtime.Span.to_ms stats.find_span);
    pr_bench "total_runtime"
      (Cache.name () ^ "total_runtime_metric")
      (Mtime.Span.to_ms stats.total_runtime_span)
end

include Cachecache.Lru.Make (K)
module Lru = Cachecache.Lru.Make (K)
module Lfu = Cachecache.Lfu.Make (K)
module Bench_lru = Make (Lru)
module Bench_lfu = Make (Lfu)

let main algo cap =
  match algo with `Lru -> Bench_lru.bench cap | `Lfu -> Bench_lfu.bench cap

open Cmdliner

let algo =
  let l = [ ("lru", `Lru); ("lfu", `Lfu) ] in
  let i = Arg.info [] in
  Arg.(required @@ pos 0 (some (enum l)) None i)

let cap =
  let i = Arg.info [] in
  Arg.(required @@ pos 1 (some int) None i)

let main_t = Term.(const main $ algo $ cap)
let cmd = Cmd.v (Cmd.info "replay") main_t
let () = exit (Cmd.eval cmd)