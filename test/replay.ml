module Make (C : Cachecache__S.Cache with type key = string) = struct
  (** The current working directory depends on whether the test binary is
      directly run or is triggered with [dune exec], [dune runtest]. We
      normalise by switching to the project root first. *)
  let goto_project_root () =
    let cwd = Fpath.v (Sys.getcwd ()) in
    match cwd |> Fpath.segs |> List.rev with
    | "test" :: "default" :: "_build" :: _ ->
        let root = cwd |> Fpath.parent |> Fpath.parent |> Fpath.parent in
        Unix.chdir (Fpath.to_string root)
    | _ -> ()

  let replay () =
    goto_project_root ();
    let path =
      let open Fpath in
      v "test" / "data" / "replace_keys.txt" |> to_string
    in
    let cap = 10 in
    let t = C.v cap in
    let chan = open_in path in
    try
      while true do
        C.replace t (input_line chan) ""
      done
    with
    | End_of_file -> close_in chan
    | e ->
        close_in chan;
        raise e

  let suite =
    [ Alcotest.test_case "Replay a trace of replace operations" `Quick replay ]
end
