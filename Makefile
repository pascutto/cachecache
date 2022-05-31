.PHONY: bench
bench:
	opam exec -- dune exec bench/replay.exe lru 5001