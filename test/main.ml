let () =
  Random.self_init ();
  Alcotest.run "CacheCache" [ Lru.suite ]
