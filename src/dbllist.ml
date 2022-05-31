type 'a cell = {
  mutable content : 'a;
  mutable prev : 'a cell;
  mutable next : 'a cell;
}

type 'a tt = Nil | List of { mutable first : 'a cell; mutable last : 'a cell }
type 'a t = 'a tt ref

let create () = ref Nil
let is_empty l = match !l with Nil -> true | List _ -> false

let append l v =
  match !l with
  | Nil ->
      let rec c = { content = v; prev = c; next = c } in
      l := List { first = c; last = c };
      c
  | List l ->
      let rec c = { content = v; prev = l.last; next = c } in
      l.last.next <- c;
      l.last <- c;
      c

let append_before l c v =
  match !l with
  | Nil -> raise Not_found
  | List l ->
      if c == l.first then (
        let rec new_cell = { content = v; prev = new_cell; next = c } in
        l.first <- new_cell;
        c.prev <- new_cell;
        new_cell)
      else
        let new_cell = { content = v; prev = c.prev; next = c } in
        c.prev.next <- new_cell;
        c.prev <- new_cell;
        new_cell

let append_after l c v =
  match !l with
  | Nil -> raise Not_found
  | List l ->
      if c == l.last then (
        let rec new_cell = { content = v; prev = c; next = new_cell } in
        l.last <- new_cell;
        c.next <- new_cell;
        new_cell)
      else
        let new_cell = { content = v; prev = c; next = c.next } in
        c.next.prev <- new_cell;
        c.next <- new_cell;
        new_cell

let clear l = l := Nil
let ends l = match !l with Nil -> assert false | List l -> (l.first, l.last)
let get c = c.content

let remove t c =
  match !t with
  | Nil -> raise Not_found
  | List l ->
      let is_first = c.prev == c in
      let is_last = c.next == c in
      if is_last && is_first then t := Nil
      else if is_first then (
        l.first <- c.next;
        c.next.prev <- c.next)
      else if is_last then (
        l.last <- c.prev;
        c.prev.next <- c.prev)
      else (
        c.next.prev <- c.prev;
        c.prev.next <- c.next)
