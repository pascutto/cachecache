module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) =
struct
  module H = Hashtbl.Make (K)

  type key = K.t
  (* type freq_index = int
     type key_index = int *)

  type 'a t = {
    lsts : key Dllist.t;
    value : ((int * key Dllist.l) Dllist.c * key Dllist.c * 'a) H.t;
    frequency : (int * key Dllist.l) Dllist.l;
    cap : int;
    stats : Stats.t;
  }

  let dummy = Obj.magic (ref 0)

  let unsafe_v c =
    let lsts = Dllist.create c dummy in
    let freq = Dllist.create c dummy |> Dllist.create_list in
    { lsts; value = H.create c; frequency = freq; cap = c; stats = Stats.v () }

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
    let freq_index, key_index, _value = H.find t.value k in
    let freq, freq_list = Dllist.get t.frequency freq_index in
    let next = Dllist.next t.frequency freq_index in
    let freq_next, _freq_next_list = Dllist.get t.frequency next in
    let new_freq_index =
      if freq_next = freq + 1 then next
      else
        let new_next = Dllist.create_list t.lsts in
        (* FIXME: t.frequency could be full at this point, and append_after would fail *)
        Dllist.append_after t.frequency freq_index (freq + 1, new_next)
    in
    Dllist.remove freq_list key_index;
    let _freq_next, freq_next_list = Dllist.get t.frequency new_freq_index in
    if Dllist.is_empty freq_list then
      (* FIXME: this should happen before, to leave room for the new value if
         t.frequency is full *)
      Dllist.remove t.frequency freq_index;
    let new_key_index, _opt = Dllist.append freq_next_list k in
    assert (_opt = None);
    (new_freq_index, new_key_index)

  let find t k =
    let _freq_index, _key_index, v = H.find t.value k in
    Stats.hit t.stats;
    let new_freq_index, new_key_index = update t k in
    H.replace t.value k (new_freq_index, new_key_index, v);
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
    if H.length t.value = 0 then (
      let first_freq_list = Dllist.create_list t.lsts in
      let new_key_index, _opt = Dllist.append first_freq_list k in
      assert (_opt = None);
      let first_key_index, _opt =
        Dllist.append t.frequency (1, first_freq_list)
      in
      assert (_opt = None);
      H.replace t.value k (first_key_index, new_key_index, v))
    else
      let first_freq_index, _last_freq_index = Dllist.ends t.frequency in
      let freq, _key_list = Dllist.get t.frequency first_freq_index in
      let new_first_freq_index =
        if freq = 1 then first_freq_index
        else
          let real_first_freq_list = Dllist.create_list t.lsts in
          Dllist.append_before t.frequency first_freq_index
            (1, real_first_freq_list)
      in
      let _freq, freq_list = Dllist.get t.frequency new_first_freq_index in
      let new_index, _opt = Dllist.append freq_list k in
      assert (_opt = None);
      H.replace t.value k (new_first_freq_index, new_index, v)

  let replace t k v =
    try
      let _freq_index, _key_index, _value = H.find t.value k in
      let new_freq_index, new_key_index = update t k in
      Stats.replace t.stats;
      H.replace t.value k (new_freq_index, new_key_index, v)
    with Not_found ->
      Stats.add (H.length t.value + 1) t.stats;
      if H.length t.value < t.cap then add t k v
      else
        let first_freq_index, _last_freq_index = Dllist.ends t.frequency in
        let _freq, freq_list = Dllist.get t.frequency first_freq_index in
        let first_index, _last_index = Dllist.ends freq_list in
        let remove_key = Dllist.get freq_list first_index in
        Dllist.remove freq_list first_index;
        if Dllist.is_empty freq_list then
          Dllist.remove t.frequency first_freq_index;
        H.remove t.value remove_key;
        Stats.discard t.stats;
        add t k v

  let remove t k =
    try
      let freq_index, key_index, _value = H.find t.value k in
      H.remove t.value k;
      let _freq, key_list = Dllist.get t.frequency freq_index in
      Dllist.remove key_list key_index;
      if Dllist.is_empty key_list then Dllist.remove t.frequency freq_index;
      Stats.remove t.stats
    with Not_found -> ()
end
