type 'a t = {
  contents : 'a array;
  witness : 'a;
  prev : int array;
  next : int array;
  mutable first : int;
  mutable last : int;
  cap : int;
  mutable size : int;
}

let create witness c =
  {
    contents = Array.make c witness;
    witness;
    prev = Array.make c (-1);
    next = Array.make c (-1);
    first = -1;
    last = -1;
    cap = c;
    size = 0;
  }

let clear t =
  t.first <- -1;
  t.last <- -1;
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
    if t.size = 0 then (
      let index = t.cap - 1 in
      t.contents.(index) <- v;
      t.last <- index;
      t.first <- index;
      t.size <- t.size + 1;
      None)
    else if t.size < t.cap then (
      let index = t.first - 1 in
      t.contents.(index) <- v;
      t.next.(index) <- t.first;
      t.prev.(t.first) <- index;
      t.first <- index;
      t.size <- t.size + 1;
      None)
    else
      let removed1 = Some t.contents.(t.last) in
      let old_last = t.last in
      t.last <- t.prev.(old_last);
      t.contents.(old_last) <- v;
      t.next.(t.prev.(old_last)) <- -1;
      t.prev.(old_last) <- -1;
      t.next.(old_last) <- t.first;
      t.prev.(t.first) <- old_last;
      t.first <- old_last;
      removed1
  in
  (t.first, removed)

let promote t i1 =
  t.next.(t.prev.(i1)) <- t.next.(i1);
  t.prev.(t.next.(i1)) <- t.prev.(i1);
  t.prev.(t.first) <- i1;
  t.next.(i1) <- t.first;
  t.prev.(i1) <- -1;
  t.first <- i1;
  t.first

let get t i1 = t.contents.(i1)

let length t = t.size
