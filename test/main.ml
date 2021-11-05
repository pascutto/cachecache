let () =
  Random.self_init ();
  Alcotest.run "LRU" Lru.suite
