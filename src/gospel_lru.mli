(** Verified LRU caches *)

module Make (K : sig
  type key

  (*@ predicate equiv (x: key) (y: key) *)
  (*@ axiom refl : forall x: key. equiv x x *)
  (*@ axiom sym  : forall x y: key. equiv x y -> equiv y x *)
  (*@ axiom trans: forall x y z:key. equiv x y -> equiv y z -> equiv x z *)

  val equal : key -> key -> bool
  (*@ b = equal x y
      ensures b <-> equiv x y *)

  val witness : unit -> key
end) (H : sig
  type 'v t

  val create : int -> 'v t

  val mem : 'v t -> K.key -> bool

  val add : 'v t -> K.key -> 'v -> unit

  val find : 'v t -> K.key -> 'v

  val remove : 'v t -> K.key -> unit

  val clear : 'v t -> unit
end) : sig
  type 'a t
  (** The type for LRU caches. *)
  (*@ ephemeral
      model cap : int
      mutable model assoc : K.key -> 'a option
      mutable model age : K.key -> int
      invariant cap > 0
      invariant forall k k'.
        not (K.equiv k k') ->
        assoc k <> None -> assoc k' <> None ->
        age k <> age k'
      invariant forall k. age k >= 0
      invariant forall k. age k >= cap <-> assoc k = None *)

  val v : int -> 'a t
  (** [v capacity] creates an empty cache with capacity [capacity]. *)
  (*@ t = v c
      checks c > 0
      ensures cap t = c
      ensures forall k. assoc t k = None *)

  val clear : 'a t -> unit
  (*@ clear t
      ensures forall k. assoc t k = None *)

  val is_empty : 'a t -> bool
  (*@ b = is_empty t
      ensures b = true <-> forall k. assoc t k = None *)

  val capacity : 'a t -> int
  (*@ c = capacity t
      ensures c = cap t *)

  val mem : K.key -> 'a t -> bool
  (*@ b = mem k t
      ensures b = true <-> assoc t k <> None *)

  val find : K.key -> 'a t -> 'a
  (*@ v = find k t
      ensures assoc t k = Some v
      raises Not_found -> assoc t k = None *)

  val find_opt : K.key -> 'a t -> 'a option
  (*@ o = find_opt k t
      ensures o = assoc t k *)

  val add : K.key -> 'a -> 'a t -> unit
  (*@ add k v t
      modifies t
      ensures assoc t k = Some v
      ensures forall k', v'.
        not (K.equiv k k') -> assoc t k' = Some v' -> assoc (old t) k' = Some v'
      ensures forall k'.
        age t k' =
          if K.equiv k k' then 0
          else if age (old t) k' < age (old t) k then age (old t) k' + 1
          else age (old t) k' *)
end
