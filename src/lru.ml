module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) =
struct
  module H = Hashtbl.Make (K)

  type key = K.t

  let dummy : K.t = Obj.magic (ref 0)

  type 'a t = {
    table : (K.t Dllist.c * 'a) H.t;
    list : K.t Dllist.l;
    cap : int;
    stats : Stats.t;
  }

  let unsafe_v c =
    {
      table = H.create c;
      list = Dllist.create c dummy |> Dllist.create_list;
      cap = c;
      stats = Stats.v ();
    }

  let v c =
    if c <= 0 then invalid_arg "capacity must be strictly positive";
    unsafe_v c

  let stats t = t.stats
  let is_empty t = Dllist.length t.list = 0
  let capacity t = t.cap
  let size t = H.length t.table

  let clear t =
    H.clear t.table;
    Dllist.clear t.list;
    Stats.clear t.stats

  let find t k =
    let index, value = H.find t.table k in
    Stats.hit t.stats;
    let new_index = Dllist.promote t.list index in
    H.replace t.table k (new_index, value);
    value

  let find_opt t k =
    try
      let result = find t k in
      Some result
    with Not_found ->
      Stats.miss t.stats;
      None

  let mem t k =
    let b = H.mem t.table k in
    if b then Stats.hit t.stats else Stats.miss t.stats;
    b

  let replace t k v =
    try
      let index, _value = H.find t.table k in
      let new_index = Dllist.promote t.list index in
      Stats.replace t.stats;
      H.replace t.table k (new_index, v)
    with Not_found ->
      let index, removed = Dllist.append t.list k in
      (match removed with
      | None -> ()
      | Some key ->
          H.remove t.table key;
          Stats.discard t.stats);
      H.replace t.table k (index, v)

  let remove t k =
    try
      let index, _value = H.find t.table k in
      Dllist.remove t.list index;
      H.remove t.table k;
      Stats.remove t.stats
    with Not_found -> ()
end
