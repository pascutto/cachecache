module Make (C : S.Cache) (DB : S.DB) = struct
  let v c = C.v c
  let stats t = C.stats t
  let is_empty t = C.is_empty t
  let capacity t = C.capacity t
  let size t = C.size t
  let clear t = C.clear t
  let mem t k = if C.mem t k then true else DB.mem k
  let find t k = try C.find t k with Not_found -> DB.find k

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

  let remove t k = if C.remove t k == 0 then DB.remove k
end
