module Make (C : S.Cache) (DB : S.DB with type key = C.key) :
  S.Through with type key = DB.key and type value = DB.value
