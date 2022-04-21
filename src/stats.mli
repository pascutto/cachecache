type t = private {
  mutable miss : int;  (** not found counter *)
  mutable hit : int;  (** found counter *)
  mutable add : int;  (** add counter *)
  mutable discard : int;  (** discard counter *)
  mutable remove : int;  (** remove counter *)
  mutable clear : int;  (** clear counter *)
  mutable max_size : int;  (** max number of value in t *)
  mutable current : int;  (** current number of value in t *)
}

val v : unit -> t
(*@ t = v ()
  ensures t.miss = 0
  ensures t.hit = 0
  ensures t.add = 0
  ensures t.discard = 0
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

val discard : t -> unit
(*@ discard t
    modifies t.discard
    ensures  t.discard = old t.discard + 1
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

val add : t -> unit
(*@ add t
  modifies t.current, t.max_size, t.add
  ensures  t.add = old t.add + 1
  ensures  t.current = old t.current + 1
  ensures t.max_size >= old t.max_size
*)

val display : t -> unit
