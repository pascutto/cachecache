.PHONY: bench
bench:
	opam install dune -y
	opam exec -- dune exec bench/replay.exe lru 5001