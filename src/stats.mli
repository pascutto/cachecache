type t = private {
  mutable miss : int;  (** miss counter *)
  mutable hit : int;  (** hit counter *)
  mutable add : int;  (** newly added bindings counter *)
  mutable replace : int;  (** overwritten bindings counter *)
  mutable discard : int;  (** discard counter *)
  mutable remove : int;  (** remove counter *)
  mutable clear : int;  (** clear counter *)
  mutable max_size : int;  (** max number of bindings *)
}

val v : unit -> t
(*@ t = v ()
  ensures t.miss = 0
  ensures t.hit = 0
  ensures t.add = 0
  ensures t.discard = 0
  ensures t.replace = 0
  ensures t.remove = 0
  ensures t.clear = 0
  ensures t.max_size = 0
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

val replace : t -> unit
(*@ replace t
    modifies t.replace
    ensures  t.replace = old t.replace + 1
*)

val remove : t -> unit
(*@ remove t
    modifies t.remove
    ensures  t.remove  = old t.remove + 1
*)

val clear : t -> unit
(*@ clear t
    modifies t.clear
    ensures  t.clear   = old t.clear + 1
*)

val add : int -> t -> unit
(*@ add new_size t
  modifies t.max_size, t.add
  ensures  t.add = old t.add + 1
  ensures  t.max_size >= old t.max_size
*)

(* val pp : Format.formatter -> t -> unit *)

