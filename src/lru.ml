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
    tbl : (K.t Dllist.c * 'a) H.t;
    lst : K.t Dllist.l;
    cap : int;
    stats : Stats.t;
  }

  let unsafe_v c =
    {
      tbl = H.create c;
      lst = Dllist.create c dummy |> Dllist.create_list;
      cap = c;
      stats = Stats.v ();
    }

  let v c =
    if c <= 0 then invalid_arg "capacity must be strictly positive";
    unsafe_v c

  let stats t = t.stats
  let is_empty t = Dllist.length t.lst = 0
  let capacity t = t.cap
  let size t = H.length t.tbl

  let clear t =
    H.clear t.tbl;
    Dllist.clear t.lst;
    Stats.clear t.stats

  let find t k =
    let index, value = H.find t.tbl k in
    Stats.hit t.stats;
    let new_index = Dllist.promote t.lst index in
    H.replace t.tbl k (new_index, value);
    value

  let find_opt t k =
    try
      let result = find t k in
      Some result
    with Not_found ->
      Stats.miss t.stats;
      None

  let mem t k =
    let b = H.mem t.tbl k in
    if b then Stats.hit t.stats else Stats.miss t.stats;
    b

  let replace t k v =
    try
      let index, _value = H.find t.tbl k in
      let new_index = Dllist.promote t.lst index in
      Stats.replace t.stats;
      H.replace t.tbl k (new_index, v)
    with Not_found ->
      let index, removed = Dllist.append t.lst k in
      (match removed with
      | None -> ()
      | Some key ->
          H.remove t.tbl key;
          Stats.discard t.stats);
      H.replace t.tbl k (index, v)

  let remove t k =
    try
      let index, _value = H.find t.tbl k in
      Dllist.remove t.lst index;
      H.remove t.tbl k;
      Stats.remove t.stats
    with Not_found -> ()
end
