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
    let index, value = C.H.find C.t.tbl k in
    let new_index = Dllist.promote t.lst index in
    H.replace t.tbl k (new_index, value);
    value*)

  let find_opt t k =
    match C.find_opt t k with
    | Some res -> Some res
    | None -> (
        try
          let result = DB.find k in
          C.replace t k result;
          Some result
        with Not_found -> None)

  let promote t k = ignore (C.find t k)

  let replace t k v =
    match C.find_opt t k with
    | Some _ -> C.replace t k v
    | None -> (
        try
          ignore (DB.find k);
          DB.replace k v;
          C.replace t k v
        with Not_found ->
          DB.add k v;
          C.replace t k v)

  let remove t k =
    (*if (C.remove t k) == 0 then B.remove k*)
    let c = C.remove t k in
    if c == 0 then DB.remove k
end
