module K = struct
  include Int

  let hash = Hashtbl.hash
end

module V = struct
  type t = int

  let weight _ = 1
end

module GLru = struct
  include Cachecache.Lru.Make (K)

  type nonrec t = int t
end

module OLru = struct
  include Lru.M.Make (K) (V)

  let v = create ~random:false
  let find_opt t k = find k t
  let mem t k = mem k t
  let replace t k v = add k v t
end

let fresh_int =
  let c = ref 0 in
  fun () ->
    incr c;
    !c

open Bechamel
open Toolkit

module type BENCH = sig
  val test : string -> Test.t
end

module Bench (Lru : sig
  type t

  val v : int -> t
  val replace : t -> K.t -> V.t -> unit
  val mem : t -> K.t -> bool
  val find_opt : t -> K.t -> V.t option
end) : BENCH = struct
  let fill n t =
    let rec loop i =
      if i = 0 then ()
      else
        let k = n - i in
        Lru.replace t k k;
        loop (i - 1)
    in
    loop n

  let v cap = Staged.stage (fun () -> Lru.v cap)

  let replace cap =
    let t = Lru.v cap in
    fill cap t;
    Staged.stage (fun () ->
        let k = fresh_int () in
        Lru.replace t k k)

  let mem_present cap =
    let t = Lru.v cap in
    fill cap t;
    Staged.stage (fun () ->
        let k = Random.int cap in
        assert (Lru.mem t k))

  let find_present cap =
    let t = Lru.v cap in
    fill cap t;
    Staged.stage (fun () ->
        let k = Random.int cap in
        assert (Lru.find_opt t k = Some k))

  let test name =
    Test.make_grouped ~name
      [
        Test.make_indexed ~name:"v" ~fmt:"%s %d"
          ~args:[ 100; 10_000; 1_000_000 ] v;
        Test.make_indexed ~name:"replace" ~fmt:"%s %d"
          ~args:[ 100; 10_000; 1_000_000 ] replace;
        Test.make_indexed ~name:"find (present)" ~fmt:"%s %d"
          ~args:[ 100; 10_000; 1_000_000 ] find_present;
        Test.make_indexed ~name:"mem (present)" ~fmt:"%s %d"
          ~args:[ 100; 10_000; 1_000_000 ] mem_present;
      ]
end

module GBench = Bench (GLru)
module OBench = Bench (OLru)

let benchmark (module B : BENCH) name =
  let ols =
    Analyze.ols ~bootstrap:0 ~r_square:true ~predictors:Measure.[| run |]
  in
  let instances =
    Instance.[ minor_allocated; major_allocated; monotonic_clock ]
  in
  let cfg =
    Benchmark.cfg ~limit:2000 ~quota:(Time.second 0.5) ~kde:(Some 1000) ()
  in
  let raw_results = Benchmark.all cfg instances (B.test name) in
  ( List.map (fun instance -> Analyze.all ols instance raw_results) instances
    |> Analyze.merge ols instances,
    raw_results )

type rect = Bechamel_notty.rect = { w : int; h : int }

let report_notty =
  let () = Bechamel_notty.Unit.add Instance.monotonic_clock "ns" in
  let () = Bechamel_notty.Unit.add Instance.minor_allocated "w" in
  let () = Bechamel_notty.Unit.add Instance.major_allocated "mw" in
  let img (window, results) =
    Bechamel_notty.Multiple.image_of_ols_results ~rect:window
      ~predictor:Measure.run results
  in
  let window =
    match Notty_unix.winsize Unix.stdout with
    | Some (_, _) -> { w = 80; h = 1 }
    | None -> { w = 80; h = 1 }
  in
  fun res -> img (window, res) |> Notty_unix.eol |> Notty_unix.output_image

let () =
  let gres = benchmark (module GBench) "CacheCache.Lru" in
  let ores = benchmark (module OBench) "Lru" in
  fst gres |> report_notty;
  fst ores |> report_notty
