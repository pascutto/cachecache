module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) =
struct
  module H = Hashtbl.Make (K)

  type key = K.t
  type freq_index = int
  type key_index = int

  type 'a t = {
    value : (freq_index * key_index * 'a) H.t;
    frequency : (int * key Dllist.t) Dllist.t;
    cap : int;
    stats : Stats.t;
  }

  type 'a l = { contents : 'a array; mutable free : int }

  let dummy : K.t = Obj.magic (ref 0)

  let unsafe_v c =
    let key_lst = { contents = Array.make c dummy; free = 0 } in
    let freq_lst = { contents = Array.make c dummy; free = 0 } in
    {
      value = H.create c;
      frequency = Dllist.create freq_lst 0 (0, Dllist.create key_lst 0 dummy);
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
    Dllist.clear t.frequency;
    Stats.clear t.stats

  let update t k =
    let freq_cell, key_cell, _value = H.find t.value k in
    let freq, freq_list = freq_cell.content in
    let freq_next, _freq_next_list = freq_cell.next.content in
    (if freq <> freq_next - 1 then
     let real_next_freq_list = Dbllist.create () in
     let real_freq = freq + 1 in
     ignore
       (Dbllist.append_after t.frequency freq_cell
          (real_freq, real_next_freq_list)
         : freq_cell));
    Dbllist.remove freq_list key_cell;
    let _freq_next, freq_next_list = freq_cell.next.content in
    if Dbllist.is_empty freq_list then Dbllist.remove t.frequency freq_cell;
    let last = Dbllist.append freq_next_list k in
    (freq_cell.next, last)

  let find t k =
    let _freq_cell, _key_cell, v = H.find t.value k in
    Stats.hit t.stats;
    let new_freq_cell, new_last_cell = update t k in
    H.replace t.value k (new_freq_cell, new_last_cell, v);
    v

  let find_opt t k =
    try Some (find t k)
    with Not_found ->
      Stats.miss t.stats;
      None

  let mem t k =
    try
      ignore (find t k);
      true
    with Not_found ->
      Stats.miss t.stats;
      false

  let add t k v =
    if H.length t.value = 0 then
      let first_freq_list = Dllist.create 0 dummy in
      let new_key_index, _opt = Dllist.append first_freq_list k in
      let first_key_index, _opt =
        Dllist.append t.frequency (1, first_freq_list)
      in
      H.replace t.value k (first_key_index, new_key_index, v)
    else
      let first_freq_index, _last_freq_index = Dllist.get_ends t.frequency in

      let freq, _key_list = Dllist.get t.frequency first_freq_index in
      (if freq <> 1 then
       let real_first_freq_list = Dllist.create 0 dummy in

       Dllist.append_before t.frequency first_freq_cell (1, real_first_freq_list));

      let first_freq_cell, _last_freq_cell = Dbllist.get t.frequency in
      let _freq, freq_list = first_freq_cell.content in
      let new_cell = Dbllist.append freq_list k in
      H.replace t.value k (first_freq_cell, new_cell, v)

  let replace t k v =
    try
      let _freq_cell, _key_cell, _value = H.find t.value k in
      let new_freq_cell, new_last_cell = update t k in
      Stats.replace t.stats;
      H.replace t.value k (new_freq_cell, new_last_cell, v)
    with Not_found ->
      Stats.add (H.length t.value + 1) t.stats;
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
        Stats.discard t.stats;
        add t k v

  let remove t k =
    try
      let freq_index, key_index, _value = H.find t.value k in
      H.remove t.value k;
      let _freq, freq_list = Dllist.get t.frequency freq_index in
      Dllist.remove freq_list key_index;
      (* if Dbllist.is_empty freq_list then Dllist.remove t.frequency freq_cell; *)
      Stats.remove t.stats
    with Not_found -> ()
end
