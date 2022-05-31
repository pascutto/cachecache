type 'a cell = private {
  mutable content : 'a;
  mutable prev : 'a cell;
  mutable next : 'a cell;
}

type 'a t

val create : unit -> 'a t
val is_empty : 'a t -> bool
val append : 'a t -> 'a -> 'a cell
val append_before : 'a t -> 'a cell -> 'a -> 'a cell
val append_after : 'a t -> 'a cell -> 'a -> 'a cell
val clear : 'a t -> unit
val ends : 'a t -> 'a cell * 'a cell
val remove : 'a t -> 'a cell -> unit
val get : 'a cell -> 'a
