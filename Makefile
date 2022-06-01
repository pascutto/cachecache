.PHONY: bench
bench:
	sudo apt-get install wget
	wget --directory-prefix=./trace http://data.tarides.com/irmin/lru.trace
	opam exec -- dune exec -- bench/replay.exe lru 5001
	opam exec -- dune exec -- bench/replay.exe lfu 5001