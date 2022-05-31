let () =
  Random.self_init ();
  let error = ref false in
  (try Alcotest.run ~and_exit:false "LRU" Lru.suite
   with Alcotest.Test_error -> error := true);
  (try Alcotest.run ~and_exit:false "LFU" Lfu.suite
   with Alcotest.Test_error -> error := true);
  if !error then exit 1 else exit 0
