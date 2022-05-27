type span = Mtime.span

let span_t = Repr.map Repr.float (fun _ -> assert false) Mtime.Span.to_s

type stats = {
  mutable add : int;
  mutable mem : int;
  mutable find : int;
  mutable add_span : span;
  mutable mem_span : span;
  mutable find_span : span;
}
[@@deriving repr ~pp]

module K = struct
  include String

  let hash = Hashtbl.hash
end

module Lru = Cachecache.Lru.Make (K)

let () =
  let stats =
    {
      add = 0;
      mem = 0;
      find = 0;
      add_span = Mtime.Span.zero;
      mem_span = Mtime.Span.zero;
      find_span = Mtime.Span.zero;
    }
  in
  let counter = Mtime_clock.counter () in
  let open Lru_trace_definition in
  let _, { instance_count }, seq =
    open_reader "/home/cha//Downloads/lru.trace"
  in
  let lrus = List.init instance_count (fun _ -> Lru.v 5000) in
  Seq.iter
    (fun { instance_id; op } ->
      let lru = List.nth lrus instance_id in
      match op with
      | Add k ->
          let before = Mtime_clock.count counter in
          Lru.replace lru k ();
          let after = Mtime_clock.count counter in
          stats.add_span <-
            Mtime.Span.(abs_diff after before |> add stats.add_span);
          stats.add <- stats.add + 1
      | Find k ->
          let before = Mtime_clock.count counter in
          ignore (Lru.find_opt lru k : _ option);
          let after = Mtime_clock.count counter in
          stats.find_span <-
            Mtime.Span.(abs_diff after before |> add stats.find_span);
          stats.find <- stats.find + 1
      | Mem k ->
          let before = Mtime_clock.count counter in
          ignore (Lru.mem lru k : bool);
          let after = Mtime_clock.count counter in
          stats.mem_span <-
            Mtime.Span.(abs_diff after before |> add stats.mem_span);
          stats.mem <- stats.mem + 1
      | _ -> ())
    seq;
  Fmt.pr "%a\n" pp_stats stats
