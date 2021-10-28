type 'a t

val create : int -> 'a -> 'a t

val length : 'a t -> int

val append : 'a t -> 'a -> int * 'a option

val promote : 'a t -> int -> int

val remove : 'a t -> int -> unit

val get : 'a t -> int -> 'a

val clear : 'a t -> unit
