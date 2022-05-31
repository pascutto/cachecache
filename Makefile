.PHONY: bench
bench:
	ls -al
	wget http://data.tarides.com/irmin/lru.trace
	opam exec -- dune exec -- bench/replay.exe lru 5001