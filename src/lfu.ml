module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
  val compare : t -> t -> int
end) =
struct
  module H = Hashtbl.Make (K)
  module Heap = Psq.Make (K) (Int)

  type 'a t = { capacity : int; mutable heap : Heap.t; dict : 'a H.t }

  let create capacity =
    let heap = Heap.empty in
    let dict = H.create capacity in
    { capacity; heap; dict }

  let find_opt t k =
    match H.find_opt t.dict k with
    | None -> None
    | Some v ->
        t.heap <- Heap.adjust k (fun p -> p + 1) t.heap;
        Some v

  let replace t k v =
    let is_full = Heap.size t.heap = t.capacity in
    match (is_full, H.find_opt t.dict k) with
    | false, None ->
        H.add t.dict k v;
        t.heap <- Heap.add k 0 t.heap
    | (false | true), Some _old_v ->
        H.replace t.dict k v;
        t.heap <- Heap.adjust k (fun p -> p + 1) t.heap
    | true, None -> (
        H.add t.dict k v;
        match Heap.pop t.heap with
        | None -> assert false
        | Some (_lfu, heap) -> t.heap <- Heap.add k 0 heap)
end
