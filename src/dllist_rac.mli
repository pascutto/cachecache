type 'a t = private {
  cap : int;
  witness : 'a;
  mutable free : int;
  contents : 'a array;
  prev : int array;
  next : int array;
}
(*@ with t
    invariant t.cap > 0
    invariant t.free >= -1
    invariant forall i. 0 <= i < t.cap -> t.next.(i) <> -1 -> t.prev.(t.next.(i)) = i
    invariant forall i. 0 <= i < t.cap -> t.prev.(i) <> -1 -> t.next.(t.prev.(i)) = i *)

type 'a l = private {
  mutable first : int;
  mutable last : int;
  mutable size : int;
  t : 'a t;
}
(*@ with l
    invariant l.first = -1 <-> l.last = -1 <-> l.size = 0
    invariant l.first = l.last <-> l.size = 1
    invariant l.size <> 0 -> l.t.prev.(l.first) = -1 /\ l.t.next.(l.last) = -1
    invariant l.size <= l.t.cap *)

type 'a c = int

val create : int -> 'a -> 'a t
(*@ t = create cap dummy
    checks cap > 0 *)

val create_list : 'a t -> 'a l
val length : 'a l -> int
val is_empty : 'a l -> bool
val is_full : 'a l -> bool
val get : 'a l -> 'a c -> 'a
val ends : 'a l -> 'a c * 'a c
val next : 'a l -> 'a c -> 'a c
val promote : 'a l -> 'a c -> 'a c
val append : 'a l -> 'a -> 'a c * 'a option
val append_before : 'a l -> 'a c -> 'a -> 'a c
val append_after : 'a l -> 'a c -> 'a -> 'a c
val remove : 'a l -> 'a c -> unit
val clear : 'a l -> unit
