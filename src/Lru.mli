(** Verified LRU caches *)

module Make (K : sig
  type key

  (*@ predicate equiv (x: key) (y: key) *)
  (*@ axiom refl : forall x: key. equiv x x *)
  (*@ axiom sym  : forall x y: key. equiv x y -> equiv y x *)
  (*@ axiom trans: forall x y z: key. equiv x y -> equiv y z -> equiv x z *)

  val equal : key -> key -> bool
  (*@ b = equal x y
      ensures b <-> equiv x y *)
  (*@ function hash_f (x: key) : integer *)
  (*@ axiom compatibility: forall x y: key. equiv x y -> hash_f x = hash_f y *)

  val hash : key -> int
  (*@ h = hash x
      ensures h = hash_f x *)
end) : sig
  type 'a lru
  (** The type for LRU caches. *)
  (*@ ephemeral
      model cap : int
      mutable model assoc : K.key -> 'a option
      mutable model age : K.key -> int
      invariant cap > 0
      invariant forall k k'. not (K.equiv k k') <-> age k <> age k'
      invariant forall k. age k >= cap <-> assoc k = None *)

  val v : int -> 'a lru
  (** [v capacity] creates an empty cache with capacity [capacity]. *)
  (*@ t = v c
      checks c > 0
      ensures cap t = c
      ensures forall k. assoc t k = None *)

  val is_empty : 'a lru -> bool
  (*@ b = is_empty t
      ensures b = true <-> forall k. assoc t k = None *)

  val capacity : 'a lru -> int
  (*@ c = capacity t
      ensures c = cap t *)

  val mem : K.key -> 'a lru -> bool
  (*@ b = mem k t
      ensures b = true <-> assoc t k <> None *)

  val find_opt : K.key -> 'a lru -> 'a option
  (*@ o = find_opt k t
      ensures o = assoc t k *)

  val add : K.key -> 'a -> 'a lru -> unit
  (*@ add k v t
      modifies t
      ensures assoc t k = Some v
      ensures forall k', v'.
        not (K.equiv k k') -> assoc t k' = Some v' -> assoc (old t) k' = Some v'
      ensures forall k'.
        age t k' = if K.equiv k k' then 0 else age (old t) k' + 1 *)
end
