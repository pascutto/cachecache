type 'a t = {
  contents : 'a array;
  witness : 'a;
  prev : int array;
  next : int array;
  mutable first : int;
  mutable last : int;
  mutable free : int;
  cap : int;
  mutable size : int;
}

type 'a l = { contents : 'a array; mutable free : int }

let create l c witness =
  {
    contents = l.contents;
    witness;
    prev = Array.init c pred;
    next = Array.init c (fun i -> if i = c - 1 then -1 else succ i);
    first = -1;
    last = -1;
    free = l.free;
    cap = c;
    size = 0;
  }

let clear t =
  t.first <- -1;
  t.last <- -1;
  t.free <- 0;
  t.size <- 0;
  let o = t.cap - 1 in
  let o1 = 0 in
  for i = o1 to o do
    t.contents.(i) <- t.witness;
    t.prev.(i) <- -1;
    t.next.(i) <- -1
  done

let append t v =
  let removed =
    if t.free <> -1 then (
      let index = t.free in
      t.free <- t.next.(t.free);
      if t.free <> -1 then t.prev.(t.free) <- -1;
      t.next.(index) <- t.first;
      if t.size = 0 then t.last <- index else t.prev.(t.first) <- index;
      t.first <- index;
      t.contents.(index) <- v;
      t.size <- t.size + 1;
      None)
    else
      let removed = Some t.contents.(t.last) in
      let new_first = t.last in
      t.last <- t.prev.(t.last);
      t.contents.(new_first) <- v;
      t.next.(t.last) <- -1;
      t.prev.(new_first) <- -1;
      t.next.(new_first) <- t.first;
      t.prev.(t.first) <- new_first;
      t.first <- new_first;
      removed
  in
  (t.first, removed)

let promote t i =
  if i <> t.first then (
    t.next.(t.prev.(i)) <- t.next.(i);
    if i <> t.last then t.prev.(t.next.(i)) <- t.prev.(i)
    else t.last <- t.prev.(i);
    t.prev.(t.first) <- i;
    t.next.(i) <- t.first;
    t.prev.(i) <- -1;
    t.first <- i);
  t.first

let remove t i =
  if i <> t.first then t.next.(t.prev.(i)) <- t.next.(i);
  if i <> t.last then t.prev.(t.next.(i)) <- t.prev.(i)
  else t.last <- t.prev.(t.last);
  if t.free <> -1 then t.prev.(t.free) <- i;
  t.next.(i) <- t.free;
  t.prev.(i) <- -1;
  t.free <- i;
  t.size <- t.size - 1

let get t i1 = t.contents.(i1)
let length t = t.size
