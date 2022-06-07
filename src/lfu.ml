module Make (K : sig
  type t

  val equal : t -> t -> bool
  val hash : t -> int
end) =
struct
  module H = Hashtbl.Make (K)

  type key = K.t

  type 'a t = {
    lists : key Dllist.t;
    table : ((int * key Dllist.l) Dllist.c * key Dllist.c * 'a) H.t;
    frequencies : (int * key Dllist.l) Dllist.l;
    cap : int;
    stats : Stats.t;
  }

  let dummy = Obj.magic (ref 0)

  let unsafe_v c =
    let lists = Dllist.create c dummy in
    let freq = Dllist.create c dummy |> Dllist.create_list in
    {
      lists;
      table = H.create c;
      frequencies = freq;
      cap = c;
      stats = Stats.v ();
    }

  let v c =
    if c <= 0 then invalid_arg "capacity must be strictly positive";
    unsafe_v c

  let stats t = t.stats
  let is_empty t = H.length t.table = 0
  let capacity t = t.cap
  let size t = H.length t.table

  let clear t =
    H.clear t.table;
    Dllist.clear t.frequencies;
    Stats.clear t.stats

  let update t k =
    let freq_index, key_index, _value = H.find t.table k in
    let freq, freq_list = Dllist.get t.frequencies freq_index in
    let next = Dllist.next t.frequencies freq_index in
    let freq_next, _freq_next_list = Dllist.get t.frequencies next in
    Dllist.remove freq_list key_index;
    let new_freq_index =
      if freq_next = freq + 1 then (
        if Dllist.is_empty freq_list then Dllist.remove t.frequencies freq_index;
        next)
      else
        let new_next = Dllist.create_list t.lists in
        if not (Dllist.is_full t.frequencies) then (
          let r =
            Dllist.append_after t.frequencies freq_index (freq + 1, new_next)
          in
          if Dllist.is_empty freq_list then
            Dllist.remove t.frequencies freq_index;
          r)
        else (
          Dllist.remove t.frequencies freq_index;
          let res =
            if next = freq_index then
              let r, _opt = Dllist.append t.frequencies (freq + 1, new_next) in
              r
            else Dllist.append_before t.frequencies next (freq + 1, new_next)
          in
          res)
    in
    let _freq_next, freq_next_list = Dllist.get t.frequencies new_freq_index in
    let new_key_index, _opt = Dllist.append freq_next_list k in
    assert (_opt = None);
    (new_freq_index, new_key_index)

  let find t k =
    let _freq_index, _key_index, v = H.find t.table k in
    Stats.hit t.stats;
    let new_freq_index, new_key_index = update t k in
    H.replace t.table k (new_freq_index, new_key_index, v);
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
    if H.length t.table = 0 then (
      let first_freq_list = Dllist.create_list t.lists in
      let new_key_index, _opt = Dllist.append first_freq_list k in
      assert (_opt = None);
      let first_key_index, _opt =
        Dllist.append t.frequencies (1, first_freq_list)
      in
      assert (_opt = None);
      H.replace t.table k (first_key_index, new_key_index, v))
    else
      let first_freq_index, _last_freq_index = Dllist.ends t.frequencies in
      let freq, _key_list = Dllist.get t.frequencies first_freq_index in
      let new_first_freq_index =
        if freq = 1 then first_freq_index
        else
          let real_first_freq_list = Dllist.create_list t.lists in
          Dllist.append_before t.frequencies first_freq_index
            (1, real_first_freq_list)
      in
      let _freq, freq_list = Dllist.get t.frequencies new_first_freq_index in
      let new_index, _opt = Dllist.append freq_list k in
      assert (_opt = None);
      H.replace t.table k (new_first_freq_index, new_index, v)

  let replace t k v =
    try
      let _freq_index, _key_index, _value = H.find t.table k in
      let new_freq_index, new_key_index = update t k in
      Stats.replace t.stats;
      H.replace t.table k (new_freq_index, new_key_index, v)
    with Not_found ->
      Stats.add (H.length t.table + 1) t.stats;
      if H.length t.table < t.cap then add t k v
      else
        let first_freq_index, _last_freq_index = Dllist.ends t.frequencies in
        let _freq, freq_list = Dllist.get t.frequencies first_freq_index in
        assert (not (Dllist.is_empty freq_list));
        let first_index, _last_index = Dllist.ends freq_list in
        let remove_key = Dllist.get freq_list first_index in
        Dllist.remove freq_list first_index;
        if Dllist.is_empty freq_list then
          Dllist.remove t.frequencies first_freq_index;
        H.remove t.table remove_key;
        Stats.discard t.stats;
        add t k v

  let remove t k =
    try
      let freq_index, key_index, _value = H.find t.table k in
      H.remove t.table k;
      let _freq, key_list = Dllist.get t.frequencies freq_index in
      Dllist.remove key_list key_index;
      if Dllist.is_empty key_list then Dllist.remove t.frequencies freq_index;
      Stats.remove t.stats
    with Not_found -> ()
end
