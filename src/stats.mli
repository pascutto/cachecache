type t = private {
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

val v : unit -> t
(*@ t = v ()
  ensures t.miss = 0
  ensures t.hit = 0
  ensures t.replace_existing = 0
  ensures t.replace_add = 0
  ensures t.replace_evict = 0
  ensures t.remove = 0
  ensures t.clear = 0
  ensures t.max_size = 0
  ensures t.current = 0
*)

val miss : t -> unit
(*@ miss t
    modifies t.miss
    ensures  t.miss = old t.miss + 1
*)

val hit : t -> unit
(*@ hit t
    modifies t.hit
    ensures  t.hit = old t.hit + 1
*)

val replace_existing : t -> unit
(*@ replace_existing t
    modifies t.replace_existing
    ensures  t.replace_existing = old t.replace_existing + 1
*)

val replace_evict : t -> unit
(*@ replace_evict t
    modifies t.replace_evict
    ensures  t.replace_evict = old t.replace_evict + 1
*)

val remove : t -> unit
(*@ remove t
    modifies t.remove, t.current
    ensures  t.remove  = old t.remove + 1
    ensures  t.current = old t.current - 1
*)

val clear : t -> unit
(*@ clear t
    modifies t.clear, t.current
    ensures  t.clear   = old t.clear + 1
    ensures  t.current = 0
*)

val replace_add : t -> unit
(*@ replace_add t
  modifies t.current, t.max_size, t.replace_add
  ensures  t.replace_add = old t.replace_add + 1
  ensures  t.current = old t.current + 1
  ensures t.max_size >= old t.max_size
*)

val display : t -> unit