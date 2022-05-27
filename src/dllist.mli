type 'a t = private {
  cap : int;
  witness : 'a;
  contents : 'a array;
  mutable free : int;
  prev : int array;
  next : int array;
}
(*@ invariant cap > 0 *)

type 'a l = private {
  mutable first : int;
  mutable last : int;
  mutable size : int;
  t : 'a t;
}

type 'a c = int

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
val status : Format.formatter -> 'a l -> unit
val is_full : 'a l -> bool