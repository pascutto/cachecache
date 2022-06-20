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
    invariant -1 <= t.free < t.cap
    invariant t.free <> -1 -> t.prev.(t.free) = -1
    invariant forall i. 0 <= i < t.cap -> -1 <= t.next.(i) < t.cap
    invariant forall i. 0 <= i < t.cap -> -1 <= t.prev.(i) < t.cap
    invariant forall i. 0 <= i < t.cap -> t.next.(i) <> -1 -> t.prev.(t.next.(i)) = i
    invariant forall i. 0 <= i < t.cap -> t.prev.(i) <> -1 -> t.next.(t.prev.(i)) = i *)

type 'a c = private int

(*@ predicate rec aux_mem (t: 'a t) (start: 'a c) (c: 'a c) =
    start = c
    \/
    (start <> -1 && aux_mem t (t.next.(start)) c)
*)

type 'a l = private {
  mutable first : int;
  mutable last : int;
  mutable size : int;
  t : 'a t;
}
(*@ with l
    invariant l.first = -1 <-> l.last = -1
    invariant l.first = -1 <-> l.size = 0
    invariant l.first = l.last <-> l.size = 1 \/ l.size = 0
    invariant l.size <> 0 -> l.t.prev.(l.first) = -1 /\ l.t.next.(l.last) = -1
    invariant l.size <= l.t.cap
    invariant forall c:int.
      0 <= c < l.t.cap ->
      aux_mem l.t l.first c ->
      c <> l.first ->
      aux_mem l.t l.first (l.t.prev.(c))
    invariant forall c:int.
      0 <= c < l.t.cap ->
      aux_mem l.t l.first c ->
      c <> l.last ->
      aux_mem l.t l.first (l.t.next.(c))
    (* Because ortac does not check internal invariants *)
    invariant l.t.cap > 0
    invariant -1 <= l.t.free < l.t.cap
    invariant l.t.free <> -1 -> l.t.prev.(l.t.free) = -1
    invariant forall i. 0 <= i < l.t.cap -> -1 <= l.t.next.(i) < l.t.cap
    invariant forall i. 0 <= i < l.t.cap -> -1 <= l.t.prev.(i) < l.t.cap
    invariant forall i. 0 <= i < l.t.cap -> l.t.next.(i) <> -1 -> l.t.prev.(l.t.next.(i)) = i
    invariant forall i. 0 <= i < l.t.cap -> l.t.prev.(i) <> -1 -> l.t.next.(l.t.prev.(i)) = i *)

val create : int -> 'a -> 'a t
(*@ t = create cap dummy
    checks cap > 0 *)

val create_list : 'a t -> 'a l
val length : 'a l -> int
(*@ pure *)

val is_empty : 'a l -> bool
(*@ b = is_empty l
    pure
    ensures b <-> l.size = 0 *)

(*@ predicate mem (l: 'a l) (c: 'a c) = not (is_empty l) /\ aux_mem l.t l.first c *)

val is_full : 'a l -> bool
(*@ b = is_full l
    pure
    ensures b <-> l.t.free = -1 *)

val get : 'a l -> 'a c -> 'a
(*@ v = get l c
    requires mem l c
    pure
    ensures v = l.t.contents.(c) *)

val ends : 'a l -> 'a c * 'a c
(*@ (fst, lst) = ends l
    requires not (is_empty l)
    pure
    ensures fst = l.first
    ensures lst = l.last *)

val next : 'a l -> 'a c -> 'a c
(*@ c = next l i
    ensures mem l i
    pure
    ensures i = l.last -> c = i
    ensures i <> l.last -> c = l.t.next.(i) *)

val promote : 'a l -> 'a c -> 'a c
(*@ c = promote l i
    requires mem l i
    modifies l
    ensures mem l c
*)

val append : 'a l -> 'a -> 'a c * 'a option
(*@ c, removed = append l v
    modifies l
    ensures c = old (l.t.free)
    ensures l.t.prev.(c) = old (l.last)
    ensures c = l.last
    ensures match removed with
            | None ->
               old l.t.free <> -1 /\
               l.size = old (l.size) + 1
            | Some r ->
               old (is_full l) /\
               is_full l /\
               r = old (l.t.contents.(l.last))
    ensures mem l c
*)

val append_before : 'a l -> 'a c -> 'a -> 'a c
(*@ c = append_before l i v
    requires not (is_full l)
    requires mem l i
    modifies l
    ensures c = old (l.t.free)
    ensures l.t.next.(c) = i
    ensures i = old (l.first) -> c = l.first
    ensures mem l c
*)

val append_after : 'a l -> 'a c -> 'a -> 'a c
(*@ c = append_after l i v
    requires not (is_full l)
    requires mem l i
    modifies l
    ensures c = old (l.t.free)
    ensures l.t.prev.(c) = i
    ensures i = old (l.last) -> c = l.last
    ensures mem l c
*)

val remove : 'a l -> 'a c -> unit
(*@ remove l c
    requires mem l c
    modifies l
    ensures c = old (l.first) -> l.first = l.t.next.(c)
    ensures c = old (l.last) -> l.last = l.t.prev.(c)
    ensures l.size = old l.size - 1
    ensures not (mem l c)
*)

val clear : 'a l -> unit
(*@ clear l
    modifies l
    ensures is_empty l *)
