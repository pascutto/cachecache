module K = struct
  type t = int

  type key = t

  let compare = Int.compare

  let equal = Int.equal

  let hash = Hashtbl.hash

  let witness () = 0
end

module V = struct
  type t = int

  let weight _ = 1
end

module GLru = struct
  module L = Gospel_lru.Make (K) (Hashtbl.Make (K))

  type t = int L.t

  let v = L.v

  let add = L.add

  let mem = L.mem

  let find_opt = L.find_opt
end

module OLru = struct
  include Lru.M.Make (K) (V)

  let v = create ~random:false

  let find_opt = find
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

  val add : K.t -> V.t -> t -> unit

  val mem : K.t -> t -> bool

  val find_opt : K.t -> t -> V.t option
end) : BENCH = struct
  let fill n t =
    let rec loop i =
      if i = 0 then ()
      else
        let k = n - i in
        Lru.add k k t;
        loop (i - 1)
    in
    loop n

  let v cap = Staged.stage (fun () -> Lru.v cap)

  let add cap =
    let t = Lru.v cap in
    fill cap t;
    Staged.stage (fun () ->
        let k = fresh_int () in
        Lru.add k k t)

  let mem_present cap =
    let t = Lru.v cap in
    fill cap t;
    Staged.stage (fun () ->
        let k = Random.int cap in
        assert (Lru.mem k t))

  let find_present cap =
    let t = Lru.v cap in
    fill cap t;
    Staged.stage (fun () ->
        let k = Random.int cap in
        assert (Lru.find_opt k t = Some k))

  let test name =
    Test.make_grouped ~name
      [
        Test.make_indexed ~name:"v" ~fmt:"%s %d"
          ~args:[ 100; 10_000; 1_000_000 ] v;
        Test.make_indexed ~name:"add" ~fmt:"%s %d"
          ~args:[ 100; 10_000; 1_000_000 ] add;
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
  let raw_results =
    Benchmark.all ~run:1000 ~quota:Benchmark.(s 5.) instances (B.test name)
  in
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

(* let report_json =
 *   let compare k0 k1 =
 *     let a = ref 0 and b = ref 0 in
 *     Scanf.sscanf k0 "%s %d" (fun _ a' -> a := a');
 *     Scanf.sscanf k1 "%s %d" (fun _ b' -> b := b');
 *     !a - !b
 *   in
 *   let nothing _ = Ok () in
 *   fun res buf ->
 *     match
 *       Bechamel_js.(
 *         emit ~dst:(Buffer buf) nothing ~compare ~x_label:Measure.run
 *           ~y_label:(Measure.label Instance.monotonic_clock)
 *           res)
 *     with
 *     | Ok () -> ()
 *     | Error (`Msg err) -> invalid_arg err *)

let () =
  let gres = benchmark (module GBench) "Gospel" in
  let ores = benchmark (module OBench) "Reference" in
  (* let buf = Buffer.create 0 in
   * report_json gres buf;
   * report_json ores buf;
   * let ch = open_out "output.json" in
   * Buffer.contents buf |> output_string ch;
   * close_out ch; *)
  fst gres |> report_notty;
  fst ores |> report_notty
