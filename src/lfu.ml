module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) =
struct
  module H = Hashtbl.Make (K)

  type key = K.t

  type 'a t = {
    value : ((int * key Dbllist.t) Dbllist.cell * key Dbllist.cell * 'a) H.t;
    frequency : (int * key Dbllist.t) Dbllist.t;
    cap : int;
    stats : Stats.t;
  }

  let unsafe_v c =
    {
      value = H.create c;
      frequency = Dbllist.create ();
      cap = c;
      stats = Stats.v ();
    }

  let v c =
    if c <= 0 then invalid_arg "capacity must be strictly positive";
    unsafe_v c

  let stats t = t.stats
  let is_empty t = H.length t.value = 0
  let capacity t = t.cap
  let size t = H.length t.value

  let clear t =
    H.clear t.value;
    Dbllist.clear t.frequency;
    Stats.clear t.stats

  let update t k =
    assert (H.mem t.value k);
    let freq_cell, key_cell, _value = H.find t.value k in
    let freq, freq_list = freq_cell.content in
    let freq_next, _freq_next_list = freq_cell.next.content in
    (if freq <> freq_next - 1 then
     let real_next_freq_list = Dbllist.create () in
     let real_freq = freq + 1 in
     ignore
       (Dbllist.append_after t.frequency freq_cell
          (real_freq, real_next_freq_list)));
    Dbllist.remove freq_list key_cell;
    let _freq_next, freq_next_list = freq_cell.next.content in
    if Dbllist.is_empty freq_list then Dbllist.remove t.frequency freq_cell;
    let last = Dbllist.append freq_next_list k in
    (freq_cell.next, last)

  let find (t : 'a t) (k : key) : 'a =
    let _freq_cell, _key_cell, v = H.find t.value k in
    let new_freq_cell, new_last_cell = update t k in
    H.replace t.value k (new_freq_cell, new_last_cell, v);
    v

  let find_opt t k = try Some (find t k) with Not_found -> None

  let mem t k =
    try
      ignore (find t k);
      true
    with Not_found -> false

  let add t k v =
    if H.length t.value = 0 then
      let first_freq_list = Dbllist.create () in
      let new_cell = Dbllist.append first_freq_list k in
      let first_freq_cell = Dbllist.append t.frequency (1, first_freq_list) in
      H.replace t.value k (first_freq_cell, new_cell, v)
    else
      let first_freq_cell, _last_freq_cell = Dbllist.get t.frequency in
      let freq, _freq_list = first_freq_cell.content in
      (if freq <> 1 then
       let real_first_freq_list = Dbllist.create () in
       ignore
         (Dbllist.append_before t.frequency first_freq_cell
            (1, real_first_freq_list)));
      let first_freq_cell, _last_freq_cell = Dbllist.get t.frequency in
      let _freq, freq_list = first_freq_cell.content in
      let new_cell = Dbllist.append freq_list k in
      H.replace t.value k (first_freq_cell, new_cell, v)

  let replace (t : 'a t) (k : key) (v : 'a) =
    try
      let _freq_cell, _key_cell, _value = H.find t.value k in
      let new_freq_cell, new_last_cell = update t k in
      H.replace t.value k (new_freq_cell, new_last_cell, v)
    with Not_found ->
      if H.length t.value < t.cap then add t k v
      else
        let first_freq_cell, _last_freq_cell = Dbllist.get t.frequency in
        let _freq, freq_list = first_freq_cell.content in
        let first_cell, _last_cell = Dbllist.get freq_list in
        Dbllist.remove freq_list first_cell;
        if Dbllist.is_empty freq_list then
          Dbllist.remove t.frequency first_freq_cell;
        let remove_key = first_cell.content in
        H.remove t.value remove_key;
        add t k v

  let remove t k =
    try
      let freq_cell, key_cell, _value = H.find t.value k in
      H.remove t.value k;
      let _freq, freq_list = freq_cell.content in
      Dbllist.remove freq_list key_cell;
      if Dbllist.is_empty freq_list then (
        let prev_freq_cell = freq_cell.prev in
        let next_freq_cell = freq_cell.next in
        prev_freq_cell.next <- next_freq_cell;
        next_freq_cell.prev <- prev_freq_cell)
    with Not_found -> ()
end
