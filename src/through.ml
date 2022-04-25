module Make (C : S.Cache) (DB : S.DB) = struct
  let v c = C.v c
  let stats t = C.stats t
  let is_empty t = C.is_empty t
  let capacity t = C.capacity t
  let size t = C.size t
  let clear t = C.clear t

  let mem t k =
    let b = C.mem t k in
    if b then b else DB.mem k

  (*let find t k =
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
        Stats.replace t.stats;
        H.replace t.tbl k (new_index, v)
      with Not_found ->
        let index, removed = Dllist.append t.lst k in
        (match removed with
        | None -> Stats.add (H.length t.tbl + 1) t.stats
        | Some key ->
            H.remove t.tbl key;
            Stats.discard t.stats);
        H.replace t.tbl k (index, v)
  *)

  let remove t k =
    (*if (C.remove t k) == 0 then B.remove k*)
    let c = C.remove t k in
    if c == 0 then DB.remove k
end
