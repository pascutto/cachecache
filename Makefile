.PHONY: bench
bench:
	opam install -y -t . 
	opam exec -- dune exec -- bench/replay.exe lru 5001