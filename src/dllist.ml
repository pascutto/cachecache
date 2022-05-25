type 'a t = {
  cap : int;
  witness : 'a;
  contents : 'a array;
  mutable free : int;
  prev : int array;
  next : int array;
}

type 'a l = {
  mutable first : int;
  mutable last : int;
  mutable size : int;
  t : 'a t;
}

let create cap witness =
  {
    cap;
    witness;
    contents = Array.make cap witness;
    free = 0;
    prev = Array.init cap pred;
    next = Array.init cap (fun i -> if i = cap - 1 then -1 else succ i);
  }

let create_list t = { first = -1; last = -1; size = 0; t }

let clear l =
  let rec aux i =
    if i = -1 then ()
    else (
      l.t.contents.(i) <- l.t.witness;
      l.t.prev.(i) <- -1;
      l.t.next.(i) <- -1;
      aux l.t.next.(i))
  in
  aux l.first;
  l.first <- -1;
  l.last <- -1;
  l.size <- 0

let append l v =
  let removed =
    if l.t.free <> -1 then (
      let index = l.t.free in
      l.t.free <- l.t.next.(l.t.free);
      if l.t.free <> -1 then l.t.prev.(l.t.free) <- -1;
      l.t.next.(index) <- l.first;
      if l.size = 0 then l.last <- index else l.t.prev.(l.first) <- index;
      l.first <- index;
      l.t.contents.(index) <- v;
      l.size <- l.size + 1;
      None)
    else
      let removed = Some l.t.contents.(l.last) in
      let new_first = l.last in
      l.last <- l.t.prev.(l.last);
      l.t.contents.(new_first) <- v;
      l.t.next.(l.last) <- -1;
      l.t.prev.(new_first) <- -1;
      l.t.next.(new_first) <- l.first;
      l.t.prev.(l.first) <- new_first;
      l.first <- new_first;
      removed
  in
  (l.first, removed)

let promote l i =
  if i <> l.first then (
    l.t.next.(l.t.prev.(i)) <- l.t.next.(i);
    if i <> l.last then l.t.prev.(l.t.next.(i)) <- l.t.prev.(i)
    else l.last <- l.t.prev.(i);
    l.t.prev.(l.first) <- i;
    l.t.next.(i) <- l.first;
    l.t.prev.(i) <- -1;
    l.first <- i);
  l.first

let remove l i =
  if i <> l.first then l.t.next.(l.t.prev.(i)) <- l.t.next.(i);
  if i <> l.last then l.t.prev.(l.t.next.(i)) <- l.t.prev.(i)
  else l.last <- l.t.prev.(l.last);
  if l.t.free <> -1 then l.t.prev.(l.t.free) <- i;
  l.t.next.(i) <- l.t.free;
  l.t.prev.(i) <- -1;
  l.t.free <- i;
  l.size <- l.size - 1

let get l i1 = l.t.contents.(i1)
let length l = l.size
