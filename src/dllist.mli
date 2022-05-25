type 'a t
type 'a l

val create : int -> 'a -> 'a t
val create_list : 'a t -> 'a l
val length : 'a l -> int
val append : 'a l -> 'a -> int * 'a option
val promote : 'a l -> int -> int
val remove : 'a l -> int -> unit
val get : 'a l -> int -> 'a
val clear : 'a l -> unit
