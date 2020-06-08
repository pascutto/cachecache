(** Verified LRU caches *)

module Make (K : sig
  type t

  (*@ predicate equiv (x: t) (y: t) *)
  (*@ axiom refl : forall x: t. equiv x x *)
  (*@ axiom sym  : forall x y: t. equiv x y -> equiv y x *)
  (*@ axiom trans: forall x y z: t. equiv x y -> equiv y z -> equiv x z *)

  val equal : t -> t -> bool
  (*@ b = equal x y
      ensures b <-> equiv x y *)
  (*@ function hash_f (x: t) : integer *)
  (*@ axiom compatibility: forall x y: t. equiv x y -> hash_f x = hash_f y *)

  val hash : t -> int
  (*@ h = hash x
      ensures h = hash_f x *)
end) : sig
  type 'a t
  (** The type for LRU caches. *)
  (*@ ephemeral
      model cap : int
      mutable model assoc : K.t -> 'a option
      mutable model age : K.t -> int
      invariant cap > 0
      invariant forall k k'. not (K.equiv k k') <-> age k <> age k'
      invariant forall k. age k >= cap <-> assoc k = None *)

  val v : int -> 'a t
  (** [v capacity] creates an empty cache with capacity [capacity]. *)
  (*@ t = v c
      checks c > 0
      ensures cap t = c
      ensures forall k. assoc t k = None *)

  val is_empty : 'a t -> bool
  (*@ b = is_empty t
      ensures b = true <-> forall k. assoc t k = None *)

  val capacity : 'a t -> int
  (*@ c = capacity t
      ensures c = cap t *)

  val mem : K.t -> 'a t -> bool
  (*@ b = mem k t
      ensures b = true <-> assoc t k <> None *)

  val find_opt : K.t -> 'a t -> 'a option
  (*@ o = find_opt k t
      ensures o = assoc t k *)

  val add : K.t -> 'a -> 'a t -> unit
  (*@ add k v t
      modifies t
      ensures assoc t k = Some v
      ensures forall k', v'.
        not (K.equiv k k') -> assoc t k' = Some v' -> assoc (old t) k' = Some v'
      ensures forall k'.
        age t k' = if K.equiv k k' then 0 else age (old t) k' + 1 *)
end
