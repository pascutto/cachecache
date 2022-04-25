module type Cache = sig
  type 'a t
  type k

  val v : int -> 'a t
  val stats : 'a t -> Stats.t
  val is_empty : 'a t -> bool
  val capacity : 'a t -> int
  val size : 'a t -> int
  val clear : 'a t -> unit
  val mem : 'a t -> k -> bool
  val find : 'a t -> k -> 'a
  val promote : 'a t -> k -> unit
  val find_opt : 'a t -> k -> 'a option
  val replace : 'a t -> k -> 'a -> unit
  val remove : 'a t -> k -> unit
end

module type DB = sig
  type k
  type v

  val mem : k -> v -> bool
  val find : k -> v
  val add : k -> v -> unit
  val remove : k -> unit
end