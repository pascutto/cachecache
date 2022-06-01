module type Cache = sig
  type 'a t
  type key

  val v : int -> 'a t
  val name : unit -> string
  val stats : 'a t -> Stats.t
  val is_empty : 'a t -> bool
  val capacity : 'a t -> int
  val size : 'a t -> int
  val clear : 'a t -> unit
  val mem : 'a t -> key -> bool
  val find : 'a t -> key -> 'a
  val find_opt : 'a t -> key -> 'a option
  val replace : 'a t -> key -> 'a -> unit
  val remove : 'a t -> key -> unit
end

module type DB = sig
  type t
  type key
  type value

  val v : unit -> t
  val mem : t -> key -> bool
  val find : t -> key -> value
  val replace : t -> key -> value -> unit
  val remove : t -> key -> unit
end

module type Through = sig
  include DB

  val v : int -> t

  module Cache : sig
    val stats : t -> Stats.t
    val is_empty : t -> bool
    val capacity : t -> int
    val size : t -> int
    val clear : t -> unit
    val mem : t -> key -> bool
    val find : t -> key -> value
    val find_opt : t -> key -> value option
    val remove : t -> key -> unit
  end
end
