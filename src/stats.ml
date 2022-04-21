type t = {
  mutable miss : int;
  mutable hit : int;
  mutable replace : int;
  mutable remove : int;
  mutable clear : int;
  mutable add : int;
  mutable max_size : int;
  mutable current : int;
}

let v =
  {
    miss = 0;
    hit = 0;
    replace = 0;
    remove = 0;
    clear = 0;
    add = 0;
    max_size = 0;
    current = 0;
  }

let miss t = t.miss <- t.miss + 1
let replace t = t.replace <- t.replace + 1

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
