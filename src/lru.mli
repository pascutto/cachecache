module Make (K : sig
  type t

  val equal : t -> t -> bool
  (*@ pure *)

  val hash : t -> int
end) : sig
  type 'a t
  (*@ ephemeral
      model cap : int
      mutable model assoc : K.t -> 'a option
      mutable model age : K.t -> int
      invariant cap > 0
      invariant forall k k'.
        not (K.equal k k') ->
        assoc k <> None -> assoc k' <> None ->
        age k <> age k'
      invariant forall k. age k >= 0
      invariant forall k. age k >= cap <-> assoc k = None *)

  val v : int -> 'a t
  (*@ t = v c
      checks c > 0
      ensures t.cap = c
      ensures forall k. t.assoc k = None *)

  val stats : 'a t -> Stats.t
  val is_empty : 'a t -> bool
  (*@ b = is_empty t
      ensures b = true <-> forall k. t.assoc k = None *)

  val capacity : 'a t -> int
  (*@ c = capacity t
      ensures c = t.cap *)

  val size : 'a t -> int
  val clear : 'a t -> unit
  (*@ clear t
      ensures forall k. t.assoc k = None *)

  val mem : 'a t -> K.t -> bool
  (*@ b = mem t k
      ensures b = true <-> t.assoc k <> None *)

  val find : 'a t -> K.t -> 'a
  (*@ v = find t k
      ensures t.assoc k = Some v
      raises Not_found -> t.assoc k = None *)

  val promote : 'a t -> K.t -> unit
  val find_opt : 'a t -> K.t -> 'a option
  (*@ o = find_opt t k
      ensures o = t.assoc k *)

  val replace : 'a t -> K.t -> 'a -> unit
  (*@ replace t k v
      modifies t
      ensures t.assoc k = Some v
      ensures forall k', v'.
        not (K.equal k k') -> t.assoc k' = Some v' -> old t.assoc k' = Some v'
      ensures forall k'.
        t.age k' =
          if K.equal k k' then 0
          else if old t.age k' < old t.age k then old t.age k' + 1
          else old t.age k' *)

  val remove : 'a t -> K.t -> unit
  (*@ remove t k
      modifies t
      ensures t.assoc k = None *)
end
