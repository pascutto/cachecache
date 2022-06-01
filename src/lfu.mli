module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) : sig
  type 'a t
  type key = K.t

  val v : int -> 'a t
  val name : unit -> string
  val stats : 'a t -> Stats.t
  val is_empty : 'a t -> bool
  val capacity : 'a t -> int
  val size : 'a t -> int
  val clear : 'a t -> unit
  val find : 'a t -> key -> 'a
  val find_opt : 'a t -> key -> 'a option
  val mem : 'a t -> key -> bool
  val replace : 'a t -> key -> 'a -> unit
  val remove : 'a t -> key -> unit
end
