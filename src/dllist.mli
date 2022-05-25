type 'a t
type 'a l
type 'a c

val create : int -> 'a -> 'a t
val create_list : 'a t -> 'a l
val length : 'a l -> int
val append : 'a l -> 'a -> 'a c * 'a option
val promote : 'a l -> 'a c -> 'a c
val remove : 'a l -> 'a c -> unit
val get : 'a l -> 'a c -> 'a
val clear : 'a l -> unit
val is_empty : 'a l -> bool
val append_before : 'a l -> 'a c -> 'a -> 'a c
val append_after : 'a l -> 'a c -> 'a -> 'a c
val next : 'a l -> 'a c -> 'a c
val ends : 'a l -> 'a c * 'a c
val status : 'a l Fmt.t
