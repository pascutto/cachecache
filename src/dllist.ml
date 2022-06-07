type 'a t = {
  cap : int;
  witness : 'a;
  mutable free : int;
  contents : 'a array;
  prev : int array;
  next : int array;
}

type 'a l = {
  mutable first : int;
  mutable last : int;
  mutable size : int;
  t : 'a t;
}

type 'a c = int

let create cap witness =
  {
    cap;
    witness;
    free = 0;
    contents = Array.make cap witness;
    prev = Array.init cap pred;
    next = Array.init cap (fun i -> if i = cap - 1 then -1 else succ i);
  }

let create_list t = { first = -1; last = -1; size = 0; t }
let length l = l.size
let is_empty l = l.size = 0
let is_full l = l.t.free == -1
let get l i = l.t.contents.(i)
let ends l = (l.first, l.last)

let next l i =
  let n = l.t.next.(i) in
  if n = -1 then i else n

let promote l i =
  if i <> l.last then (
    l.t.prev.(l.t.next.(i)) <- l.t.prev.(i);
    if i = l.first then l.first <- l.t.next.(i)
    else l.t.next.(l.t.prev.(i)) <- l.t.next.(i);
    l.t.next.(l.last) <- i;
    l.t.prev.(i) <- l.last;
    l.t.next.(i) <- -1;
    l.last <- i);
  l.last

let append l v =
  let removed =
    if l.t.free <> -1 then (
      let index = l.t.free in
      l.t.free <- l.t.next.(l.t.free);
      if l.t.free <> -1 then l.t.prev.(l.t.free) <- -1;
      l.t.next.(index) <- -1;
      if l.size = 0 then l.first <- index else l.t.next.(l.last) <- index;
      l.t.prev.(index) <- l.last;
      l.last <- index;
      l.t.contents.(index) <- v;
      l.size <- l.size + 1;
      None)
    else
      let removed = Some l.t.contents.(l.first) in
      let index = l.first in
      l.t.prev.(l.t.next.(l.first)) <- -1;
      l.first <- l.t.next.(l.first);
      l.t.prev.(index) <- l.last;
      l.t.next.(l.last) <- index;
      l.last <- index;
      l.t.contents.(index) <- v;
      l.t.next.(index) <- -1;
      removed
  in
  (l.last, removed)

let append_before l i v =
  let new_index = l.t.free in
  l.t.free <- l.t.next.(l.t.free);
  if l.t.free <> -1 then l.t.prev.(l.t.free) <- -1;
  if l.first = i then l.first <- new_index
  else l.t.next.(l.t.prev.(i)) <- new_index;
  l.t.next.(new_index) <- i;
  l.t.prev.(new_index) <- l.t.prev.(i);
  l.t.prev.(i) <- new_index;
  l.t.contents.(new_index) <- v;
  l.size <- l.size + 1;
  new_index

let append_after l i v =
  let new_index = l.t.free in
  assert (new_index <> -1);
  l.t.free <- l.t.next.(l.t.free);
  if l.t.free <> -1 then l.t.prev.(l.t.free) <- -1;
  if l.last = i then l.last <- new_index
  else l.t.prev.(l.t.next.(i)) <- new_index;
  l.t.prev.(new_index) <- i;
  l.t.next.(new_index) <- l.t.next.(i);
  l.t.next.(i) <- new_index;
  l.t.contents.(new_index) <- v;
  l.size <- l.size + 1;
  new_index

let remove l i =
  if i = l.first then l.first <- l.t.next.(l.first)
  else l.t.next.(l.t.prev.(i)) <- l.t.next.(i);
  if i = l.last then l.last <- l.t.prev.(l.last)
  else l.t.prev.(l.t.next.(i)) <- l.t.prev.(i);
  if l.t.free <> -1 then l.t.prev.(l.t.free) <- i;
  l.t.next.(i) <- l.t.free;
  l.t.prev.(i) <- -1;
  l.t.free <- i;
  l.size <- l.size - 1;
  l.t.contents.(i) <- l.t.witness

let clear l =
  let rec aux i =
    if i = -1 then ()
    else (
      l.t.contents.(i) <- l.t.witness;
      l.t.prev.(i) <- -1;
      l.t.prev.(l.t.free) <- i;
      l.t.next.(i) <- l.t.free;
      l.t.free <- i;
      aux l.t.next.(i))
  in
  aux l.first;
  l.first <- -1;
  l.last <- -1;
  l.size <- 0
