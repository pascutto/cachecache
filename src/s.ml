module type Cache = sig
  type 'a t

  val v : int -> 'a t
  val stats : 'a t -> Stats.t
  val is_empty : 'a t -> bool
  val capacity : 'a t -> int
  val size : 'a t -> int
  val clear : 'a t -> unit
  (*val mem : 'a t -> K.t -> bool
    val find : 'a t -> K.t -> 'a
    val promote : 'a t -> K.t -> unit
    val find_opt : 'a t -> K.t -> 'a option
    val replace : 'a t -> K.t -> 'a -> unit
    val remove : 'a t -> K.t -> unit*)
end

module type BD = sig
  type k
  type v

  val mem : k -> v -> bool
  val find : k -> v
  val add : k -> v -> unit
end