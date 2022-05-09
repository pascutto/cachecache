let () =
  Random.self_init ();
  (*Alcotest.run "LRU" Lru.suite;*)
  Alcotest.run "LFU" Lfu.suite