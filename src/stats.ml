type t = {
  mutable miss : int;
  mutable hit : int;
  mutable add : int;
  mutable discard : int;
  mutable remove : int;
  mutable clear : int;
  mutable max_size : int;
  mutable current : int;
}

let v () =
  {
    miss = 0;
    hit = 0;
    remove = 0;
    clear = 0;
    add = 0;
    discard = 0;
    max_size = 0;
    current = 0;
  }

let miss t = t.miss <- t.miss + 1
let hit t = t.hit <- t.hit + 1
let discard t = t.discard <- t.discard + 1

let remove t =
  t.remove <- t.remove + 1;
  t.current <- t.current - 1

let clear t =
  t.clear <- t.clear + 1;
  t.current <- 0

let add t =
  t.add <- t.add + 1;
  t.current <- t.current + 1;
  if t.max_size < t.current then t.max_size <- t.current

let display t =
  Format.printf "find miss        : %d\n" t.miss;
  Format.printf "find hit         : %d\n" t.hit;
  Format.printf "add      : %d\n" t.add;
  Format.printf "discard    : %d\n" t.discard;
  Format.printf "remove           : %d\n" t.remove;
  Format.printf "clear            : %d\n" t.clear;
  Format.printf "maximal size     : %d\n" t.max_size
