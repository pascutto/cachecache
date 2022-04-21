module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) =
struct
  module H = Hashtbl.Make (K)

  let dummy : K.t = Obj.magic (ref 0)

  type 'a t = {
    tbl : (int * 'a) H.t;
    lst : K.t Dllist.t;
    cap : int;
    stats : Stats.t;
  }

  let unsafe_v c =
    {
      tbl = H.create c;
      lst = Dllist.create c dummy;
      cap = c;
      stats = Stats.v ();
    }

  let v c =
    if c <= 0 then invalid_arg "capacity must be strictly positive";
    unsafe_v c

  let is_empty t = Dllist.length t.lst = 0
  let capacity t = t.cap
  let size t = H.length t.tbl

  let clear t =
    H.clear t.tbl;
    Dllist.clear t.lst;
    Stats.clear t.stats

  let mem t k = H.mem t.tbl k

  let find t k =
    let index, value = H.find t.tbl k in
    let new_index = Dllist.promote t.lst index in
    H.replace t.tbl k (new_index, value);
    value

  let find_opt t k =
    try
      let result = find t k in
      Stats.hit t.stats;
      Some result
    with Not_found ->
      Stats.miss t.stats;
      None

  let promote t k = ignore (find t k)

  let replace t k v =
    try
      let index, _value = H.find t.tbl k in
      let new_index = Dllist.promote t.lst index in
      H.replace t.tbl k (new_index, v);
      Stats.replace t.stats
    with Not_found ->
      let index, removed = Dllist.append t.lst k in
      (match removed with None -> () | Some key -> H.remove t.tbl key);
      H.replace t.tbl k (index, v);
      Stats.add t.stats

  let remove t k =
    try
      let index, _value = H.find t.tbl k in
      Dllist.remove t.lst index;
      H.remove t.tbl k;
      Stats.remove t.stats
    with Not_found -> ()
end
