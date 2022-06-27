type t = {
  mutable miss : int;
  mutable hit : int;
  mutable add : int;
  mutable replace : int;
  mutable discard : int;
  mutable remove : int;
  mutable clear : int;
  mutable max_size : int;
}

let v () =
  {
    miss = 0;
    hit = 0;
    add = 0;
    replace = 0;
    discard = 0;
    remove = 0;
    clear = 0;
    max_size = 0;
  }

let miss t = t.miss <- t.miss + 1
let hit t = t.hit <- t.hit + 1
let discard t = t.discard <- t.discard + 1
let replace t = t.replace <- t.replace + 1
let remove t = t.remove <- t.remove + 1
let clear t = t.clear <- t.clear + 1

let add new_size t =
  t.add <- t.add + 1;
  if t.max_size < new_size then t.max_size <- new_size

(* let pp ppf t =
  Fmt.pf ppf
    {|miss             : %d
  hit              : %d
  add              : %d
  replace          : %d
  discard          : %d
  remove           : %d
  clear            : %d
  maximal size     : %d|}
    t.miss t.hit t.add t.replace t.discard t.remove t.clear t.max_size *)
