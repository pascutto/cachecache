module Make (C : S.Cache) (DB : S.DB) = struct
  let v c = C.v c
  let stats t = C.stats t
  let is_empty t = C.is_empty t
  let capacity t = C.capacity t
  let size t = C.size t
  let clear t = C.clear t
  let mem t k = C.mem t k || DB.mem k
  let find t k = try C.find t k with Not_found -> DB.find k

  let find_opt t k =
    try Some (C.find t k)
    with Not_found -> (
      try
        let res = DB.find k in
        C.replace t k res;
        Some res
      with Not_found -> None)

  let promote t k =
    (if not (C.mem t k) then
     try C.replace t k (DB.find k) with Not_found -> ());
    C.promote t k

  let replace t k v =
    if not (C.mem t k || DB.mem k) then DB.replace k v;
    C.replace t k v

  let remove t k =
    C.remove t k;
    DB.remove k
end
