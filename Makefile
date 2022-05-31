.PHONY: bench
bench:
	wget -O lru.trace -c http://data.tarides.com/irmin/lru.trace
	opam exec -- dune exec -- bench/replay.exe lru 5001