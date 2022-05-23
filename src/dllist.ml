type 'a t = {
  contents : 'a Vector.t;
  witness : 'a;
  prev : int Vector.t;
  next : int Vector.t;
  mutable first : int;
  mutable last : int;
  mutable free : int;
  cap : int;
  mutable size : int;
}

let create c witness =
  {
    contents = Vector.make c ~dummy:witness;
    witness;
    prev = Vector.init c ~dummy:0 pred;
    next = Vector.init c ~dummy:0 (fun i -> if i = c - 1 then -1 else succ i);
    first = -1;
    last = -1;
    free = 0;
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
    Vector.set t.contents i t.witness;
    Vector.set t.prev i (-1);
    Vector.set t.next i (-1)
  done

let append t v =
  let removed =
    if t.free <> -1 then (
      let index = t.free in
      t.free <- Vector.get t.next t.free;
      if t.free <> -1 then Vector.set t.prev t.free (-1);
      Vector.set t.next index t.first;
      if t.size = 0 then t.last <- index else Vector.set t.prev t.first index;
      t.first <- index;
      Vector.set t.contents index v;
      t.size <- t.size + 1;
      None)
    else
      let removed = Some (Vector.get t.contents t.last) in
      let new_first = t.last in
      t.last <- Vector.get t.prev t.last;
      Vector.set t.contents new_first v;
      Vector.set t.next t.last (-1);
      Vector.set t.prev new_first (-1);
      Vector.set t.next new_first t.first;
      Vector.set t.prev t.first new_first;
      t.first <- new_first;
      removed
  in
  (t.first, removed)

let promote t i =
  if i <> t.first then (
    Vector.set t.next (Vector.get t.prev i) (Vector.get t.next i);
    if i <> t.last then
      Vector.set t.prev (Vector.get t.next i) (Vector.get t.prev i)
    else t.last <- Vector.get t.prev i;
    Vector.set t.prev t.first i;
    Vector.set t.next i t.first;
    Vector.set t.prev i (-1);
    t.first <- i);
  t.first

let remove t i =
  if i <> t.first then
    Vector.set t.next (Vector.get t.prev i) (Vector.get t.next i);
  if i <> t.last then
    Vector.set t.prev (Vector.get t.next i) (Vector.get t.prev i)
  else t.last <- Vector.get t.prev t.last;
  if t.free <> -1 then Vector.set t.prev t.free i;
  Vector.set t.next i t.free;
  Vector.set t.prev i (-1);
  t.free <- i;
  t.size <- t.size - 1

let get t i1 = Vector.get t.contents i1
let length t = t.size
