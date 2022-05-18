module Test (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
  val v : unit -> t
  val pp : t Fmt.t
end) =
struct
  module Cache = Cachecache.Lru.Make (K)
  module H = Hashtbl.Make (K)

  module DB = struct
    type value = K.t
    type key = K.t
    type t = value H.t

    let v () = H.create 0
    let mem = H.mem
    let find = H.find
    let replace = H.replace
    let remove = H.remove
  end

  module DB_Cached = Cachecache.Through.Make (Cache) (DB)

  let key = Alcotest.testable K.pp K.equal

  let split l n =
    let rec aux acc l n =
      match (l, n) with
      | _, 0 -> (acc, l)
      | h :: t, n when n > 0 -> aux (h :: acc) t (n - 1)
      | _, _ -> assert false
    in
    aux [] l n

  let add_fresh_value db_t t =
    let k = K.v () in
    DB_Cached.replace db_t k k;
    Cache.replace t k k;
    k

  let add_fresh_values ~check db_t t n =
    let rec loop l i =
      if i = 0 then l
      else
        let k = add_fresh_value db_t t in
        if check then (
          Alcotest.(check bool)
            "[Though-DB] Value just added is found (mem)" true
            (DB_Cached.mem db_t k);
          Alcotest.(check key)
            "[Through-DB] Value just added is found (find)" k
            (DB_Cached.find db_t k);
          Alcotest.(check bool)
            "[Through-cache] Value just added is found (mem)" true
            (DB_Cached.Cache.mem db_t k);
          Alcotest.(check key)
            "[Through-cache] Value just added is found in cache (find)" k
            (DB_Cached.Cache.find db_t k);
          Alcotest.(check bool)
            "[Direct] Value just added is found (mem)" true (Cache.mem t k);
          Alcotest.(check key)
            "[Direct] Value just added is found (find)" k (Cache.find t k));
        loop (k :: l) (i - 1)
    in
    loop [] n

  let mem () =
    let cap = 10 in
    let db_t = DB_Cached.v cap in
    let t = Cache.v cap in
    ignore (add_fresh_values ~check:true db_t t cap : K.t list)

  let mem_over_capacity () =
    let cap = 10 in
    let db_t = DB_Cached.v cap in
    let t = Cache.v cap in
    ignore (add_fresh_values ~check:true db_t t (2 * cap) : K.t list)

  let discard () =
    let cap = 10 in
    let db_t = DB_Cached.v cap in
    let t = Cache.v cap in
    let all_values = add_fresh_values ~check:false db_t t (2 * cap) in
    let still_present, removed = split all_values cap in
    let test_in_db k =
      Alcotest.(check bool)
        "[Through-DB] All values are present" true (DB_Cached.mem db_t k)
    in
    List.iter
      (fun k ->
        Alcotest.(check bool)
          "[Through-cache] Recently added values are still present" true
          (DB_Cached.Cache.mem db_t k);
        Alcotest.(check bool)
          "[Direct] Recently added values are still present" true
          (Cache.mem t k);
        test_in_db k)
      still_present;
    List.iter
      (fun k ->
        Alcotest.(check bool)
          "[Through-cache] Old values have been removed" false
          (DB_Cached.Cache.mem db_t k);
        Alcotest.(check bool)
          "[Direct] Old values have been removed" false (Cache.mem t k);
        test_in_db k)
      removed

  let remove () =
    let cap = 10 in
    let db_t = DB_Cached.v cap in
    let t = Cache.v cap in
    let all_values = add_fresh_values ~check:false db_t t (2 * cap) in
    let recent, _old = split all_values cap in
    let removed, kept = List.partition (fun _ -> Random.bool ()) recent in
    List.iter
      (fun k ->
        DB_Cached.remove db_t k;
        Cache.remove t k)
      removed;
    List.iter
      (fun k ->
        Alcotest.(check bool)
          "[Through-DB] Removed values are not present" false
          (DB_Cached.mem db_t k);
        Alcotest.(check bool)
          "[Through-cache] Removed values are not present" false
          (DB_Cached.Cache.mem db_t k);
        Alcotest.(check bool)
          "[Direct] Removed values are not present" false (Cache.mem t k))
      removed;
    List.iter
      (fun k ->
        Alcotest.(check bool)
          "[Through-DB] Other values are present" true (DB_Cached.mem db_t k);
        Alcotest.(check bool)
          "[Through-cache] Other values are present" true
          (DB_Cached.Cache.mem db_t k);
        Alcotest.(check bool)
          "[Direct] Other values are present" true (Cache.mem t k))
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

module Lru = Cachecache.Lru.Make (struct
  include String

  let hash = Hashtbl.hash
end)

module Replay = Replay.Make (Lru)

let suite =
  [
    ("int", TInt.suite);
    ("float", TFloat.suite);
    ("string", TString.suite);
    ("int array", TInt_array.suite);
    ("replay", Replay.suite);
  ]
