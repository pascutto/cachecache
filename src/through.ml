module Make (C : S.Cache) (DB : S.DB with type key = C.key) = struct
  type t = { cache : DB.value C.t; db : DB.t }
  type key = C.key
  type value = DB.value

  let v c = { cache = C.v c; db = DB.v () }

  let mem { cache; db } k =
    C.mem cache k
    ||
    try
      let v = DB.find db k in
      C.replace cache k v;
      true
    with Not_found -> false

  let find { cache; db } k =
    try C.find cache k
    with Not_found ->
      let v = DB.find db k in
      C.replace cache k v;
      v

  let replace { cache; db } k v =
    C.replace cache k v;
    DB.replace db k v

  let remove { cache; db } k =
    C.remove cache k;
    DB.remove db k

  module Cache = struct
    let stats t = C.stats t.cache
    let is_empty t = C.is_empty t.cache
    let capacity t = C.capacity t.cache
    let size t = C.size t.cache
    let clear t = C.clear t.cache
    let mem t = C.mem t.cache
    let find t = C.find t.cache
    let find_opt t = C.find_opt t.cache
    let remove t = C.remove t.cache
  end
end
