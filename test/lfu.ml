module Test (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
  val v : unit -> t
  val pp : t Fmt.t
end) =
struct
  module Lfu = Cachecache.Lfu.Make (K)

  let key = Alcotest.testable K.pp K.equal

  let split l n =
    let rec aux acc l n =
      match (l, n) with
      | _, 0 -> (acc, l)
      | h :: t, n when n > 0 -> aux (h :: acc) t (n - 1)
      | _, _ -> assert false
    in
    aux [] l n

  let add_fresh_value t =
    let k = K.v () in
    Lfu.replace t k k;
    k

  let add_fresh_values ~check t n =
    let rec loop l i =
      Fmt.pr "i = %d@." i;
      if i = 0 then l
      else
        let k = add_fresh_value t in
        if check then (
          Alcotest.(check bool)
            "Value just added is found (mem)" true (Lfu.mem t k);
          Alcotest.(check key)
            "Value just added is found (find)" k (Lfu.find t k));
        loop (k :: l) (i - 1)
    in
    loop [] n

  let mem () =
    let cap = 10 in
    let t = Lfu.v cap in
    ignore (add_fresh_values ~check:true t cap : K.t list)

  let mem_over_capacity () =
    let cap = 10 in
    let t = Lfu.v cap in
    ignore (add_fresh_values ~check:true t (2 * cap) : K.t list)

  let discard () =
    let cap = 10 in
    let t = Lfu.v cap in
    let all_values = add_fresh_values ~check:false t cap in
    match all_values with
    | h :: tl ->
        List.iter
          (fun k ->
            Alcotest.(check bool)
              "Added values are still present" true (Lfu.mem t k))
          tl;
        let k = K.v () in
        Lfu.replace t k k;
        Alcotest.(check int) "Size is still ten" 10 (Lfu.size t);
        Alcotest.(check bool) "Unused value are removed" false (Lfu.mem t h);
        Alcotest.(check bool) "Added value is still present" true (Lfu.mem t k)
    | [] -> assert false

  let remove () =
    let cap = 10 in
    let t = Lfu.v cap in
    let all_values = add_fresh_values ~check:false t (2 * cap) in
    let recent, _old = split all_values cap in
    let removed, kept = List.partition (fun _ -> Random.bool ()) recent in
    List.iter (Lfu.remove t) removed;
    List.iter
      (fun k ->
        Alcotest.(check bool)
          "Removed values are not present" false (Lfu.mem t k))
      removed;
    List.iter
      (fun k ->
        Alcotest.(check bool) "Other values are present" true (Lfu.mem t k))
      kept

  let suite =
    [
      Alcotest.test_case "Mem finds value just added" `Quick mem;
      Alcotest.test_case "Mem finds value just added over capacity" `Quick
        mem_over_capacity;
      Alcotest.test_case "Correct values are being discarded" `Quick discard;
      Alcotest.test_case "Removed values are not found" `Quick remove;
    ]
end

module TInt = Test (struct
  include Int

  let hash = Hashtbl.hash
  let v () = Random.int ((1 lsl 30) - 1)
  let pp = Fmt.int
end)

module TFloat = Test (struct
  include Float

  let hash = Hashtbl.hash
  let v () = Random.float Float.max_float
  let pp = Fmt.float
end)

module TString = Test (struct
  include String

  let hash = Hashtbl.hash

  let v () =
    let n = Random.int 1024 in
    String.init n (fun _ -> Char.chr (Random.int 256))

  let pp = Fmt.string
end)

module TInt_array = Test (struct
  type t = int array

  let equal a b =
    let len_a = Array.length a in
    Int.equal len_a (Array.length b)
    &&
    let rec loop = function
      | -1 -> true
      | i -> Int.equal a.(i) b.(i) && loop (pred i)
    in
    loop (pred len_a)

  let hash = Hashtbl.hash

  let v () =
    let n = Random.int 1024 in
    Array.init n (fun _ -> Random.int ((1 lsl 30) - 1))

  let pp = Fmt.(array int)
end)

let suite =
  [
    ("int", TInt.suite);
    ("float", TFloat.suite);
    ("string", TString.suite);
    ("int array", TInt_array.suite);
  ]
