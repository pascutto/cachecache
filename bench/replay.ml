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

let pr_bench test_name metric_name value =
  Format.printf
    {|{"results": [{"name": "%s", "metrics": [{"name": "%s", "value": %f, "units": "ms"}]}]}@.|}
    test_name metric_name value

let mtime s counter (f : unit -> unit) =
  let t = Mtime_clock.count counter in
  f ();
  let t =
    Mtime.Span.to_ms (Mtime.Span.abs_diff (Mtime_clock.count counter) t)
  in
  s.total_runtime_span <- s.total_runtime_span +. t;
  t

module Make (Cache : Cachecache.S.Cache with type key = K.t) = struct
  let bench name cap =
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
    pr_bench name "add" stats.add_span;
    (* pr_bench name "mem" stats.mem_span; *)
    pr_bench name "find" stats.find_span;
    pr_bench name "total_runtime" stats.total_runtime_span
end

include Cachecache.Lru.Make (K)
module Lru = Cachecache.Lru.Make (K)
module Lfu = Cachecache.Lfu.Make (K)
module Bench_lru = Make (Lru)
module Bench_lfu = Make (Lfu)

(* let main algo cap =
     match algo with `Lru -> Bench_lru.bench cap | `Lfu -> Bench_lfu.bench cap

   open Cmdliner

   let algo = *)
(* let l = [ ("lru", `Lru); ("lfu", `Lfu) ] in *)
(* let i = Arg.info [] in
   Arg.(required @@ pos 0 (some (enum l)) None i) *)

(* let cap =
   let i = Arg.info [] in
   Arg.(required @@ pos 1 (some int) None i) *)

(* let main_t = Term.(const main $ algo $ cap) *)
(* let cmd = Cmd.v (Cmd.info "replay") main_t *)

let () =
  (* exit (Cmd.eval cmd) ; *)
  let t = [| 1000; 10000; 100000 |] in
  for _ = 0 to 2 do
    for cap = 0 to Array.length t - 1 do
      Bench_lru.bench "lru" t.(cap);
      Bench_lfu.bench "lfu" t.(cap)
    done
  done
