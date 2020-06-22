module K = struct
  type t = int

  type key = t

  let equal = Int.equal

  let hash = Hashtbl.hash

  let witness () = 0
end

module Lru = Gospel_lru.Make (K) (Hashtbl.Make (K))

let split l n =
  let rec aux acc l n =
    match (l, n) with
    | _, 0 -> (acc, l)
    | h :: t, n when n > 0 -> aux (h :: acc) t (n - 1)
    | _, _ -> assert false
  in
  aux [] l n

let fresh_int =
  let c = ref 0 in
  fun () ->
    incr c;
    !c

let add_fresh_value t =
  let k = fresh_int () in
  Lru.add k k t;
  k

let add_fresh_values ~check t n =
  let rec loop l i =
    if i = 0 then l
    else
      let k = add_fresh_value t in
      if check then (
        Alcotest.(check bool)
          "Value just added is found (mem)" true (Lru.mem k t);
        Alcotest.(check int) "Value just added is found (find)" k (Lru.find k t)
        );
      loop (k :: l) (i - 1)
  in
  loop [] n

let add_no_crash () =
  let cap = 10 in
  let t = Lru.v cap in
  add_fresh_values ~check:false t cap |> ignore

let add_no_crash_over_capacity () =
  let cap = 10 in
  let t = Lru.v cap in
  add_fresh_values ~check:false t (2 * cap) |> ignore

let mem () =
  let cap = 10 in
  let t = Lru.v cap in
  add_fresh_values ~check:true t cap |> ignore

let mem_over_capacity () =
  let cap = 10 in
  let t = Lru.v cap in
  add_fresh_values ~check:true t (2 * cap) |> ignore

let discard () =
  let cap = 10 in
  let t = Lru.v cap in
  let all_values = add_fresh_values ~check:false t (2 * cap) in
  let still_present, removed = split all_values cap in
  List.iter
    (fun k ->
      Alcotest.(check bool)
        "Recently added values are still present" true (Lru.mem k t))
    still_present;
  List.iter
    (fun k ->
      Alcotest.(check bool) "Old values have been removed" false (Lru.mem k t))
    removed

let () =
  Random.self_init ();
  Alcotest.run "Lru"
    [
      ( "basic",
        [
          Alcotest.test_case "Adds do not crash the LRU" `Quick add_no_crash;
          Alcotest.test_case "Adds do not crash the LRU over capacity" `Quick
            add_no_crash_over_capacity;
          Alcotest.test_case "Mem finds value just added" `Quick mem;
          Alcotest.test_case "Mem finds value just added over capacity" `Quick
            mem_over_capacity;
          Alcotest.test_case "Correct values are being discarded" `Quick discard;
        ] );
    ]
