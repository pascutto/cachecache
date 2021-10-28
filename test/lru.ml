module Lru = Cachecache.Lru.Make (struct
  include Int

  let hash = Hashtbl.hash
end)

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
  Lru.replace t k k;
  k

let add_fresh_values ~check t n =
  let rec loop l i =
    if i = 0 then l
    else
      let k = add_fresh_value t in
      if check then (
        Alcotest.(check bool)
          "Value just added is found (mem)" true (Lru.mem t k);
        Alcotest.(check int) "Value just added is found (find)" k (Lru.find t k));
      loop (k :: l) (i - 1)
  in
  loop [] n

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
        "Recently added values are still present" true (Lru.mem t k))
    still_present;
  List.iter
    (fun k ->
      Alcotest.(check bool) "Old values have been removed" false (Lru.mem t k))
    removed

let remove () =
  let cap = 10 in
  let t = Lru.v cap in
  let all_values = add_fresh_values ~check:false t (2 * cap) in
  let still_present, _ = split all_values cap in
  List.iter (fun k -> if k mod 2 = 0 then Lru.remove t k) still_present;
  List.iter
    (fun k ->
      if k mod 2 = 0 then
        Alcotest.(check bool)
          "Removed values are not present" false (Lru.mem t k)
      else Alcotest.(check bool) "Other values are present" true (Lru.mem t k))
    still_present

let suite =
  ( "lru",
    [
      Alcotest.test_case "Mem finds value just added" `Quick mem;
      Alcotest.test_case "Mem finds value just added over capacity" `Quick
        mem_over_capacity;
      Alcotest.test_case "Correct values are being discarded" `Quick discard;
      Alcotest.test_case "Removed values are not found" `Quick remove;
    ] )
