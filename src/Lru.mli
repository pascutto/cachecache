(** Verified LRU caches *)

module Make (K : sig
  type t

  val equal : t -> t -> bool

  val hash : t -> int
end) (V : sig
  type t

  val weight : t -> int
end) : sig
  (** The type for LRU caches. *)
  type t

  (** The type for keys. *)
  type key = K.t

  (** The type for values. *)
  type value = V.t

  val v : int -> t
  (** [v capacity] creates an empty cache with capacity [capacity]. *)

  val is_empty : t -> bool

  val size : t -> int

  val mem : key -> t -> bool

  val find : key -> t -> value option

  val add : key -> value -> t -> unit
end
