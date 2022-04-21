type t = {
  mutable miss : int;
  mutable hit : int;
  (*mutable replace : int;*)
  mutable replace_existing : int;
  mutable replace_add : int;
  mutable replace_evict : int;
  mutable remove : int;
  mutable clear : int;
  (*mutable add : int;*)
  mutable max_size : int;
  mutable current : int;
}

let v () =
  {
    miss = 0;
    hit = 0;
    (*replace = 0;*)
    remove = 0;
    clear = 0;
    replace_existing = 0;
    replace_add = 0;
    replace_evict = 0;
    (*add = 0;*)
    max_size = 0;
    current = 0;
  }

let miss t = t.miss <- t.miss + 1
let hit t = t.hit <- t.hit + 1
let replace_existing t = t.replace_existing <- t.replace_existing + 1
let replace_evict t = t.replace_evict <- t.replace_evict + 1

let remove t =
  t.remove <- t.remove + 1;
  t.current <- t.current - 1

let clear t =
  t.clear <- t.clear + 1;
  t.current <- 0

let replace_add t =
  t.replace_add <- t.replace_add + 1;
  t.current <- t.current + 1;
  if t.max_size < t.current then t.max_size <- t.current

let display t =
  Format.printf "find miss        : %d\n" t.miss;
  Format.printf "find hit         : %d\n" t.hit;
  Format.printf "replace_existing : %d\n" t.replace_existing;
  Format.printf "replace_add      : %d\n" t.replace_add;
  Format.printf "replace_evict    : %d\n" t.replace_evict;
  Format.printf "remove           : %d\n" t.remove;
  Format.printf "clear            : %d\n" t.clear;
  Format.printf "maximal size     : %d\n" t.max_size
