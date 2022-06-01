.PHONY: bench
bench:
	sudo apt-get install wget
	wget --directory-prefix=./trace/lru.trace http://data.tarides.com/irmin/lru.trace
	opam exec -- dune exec -- bench/replay.exe lru 5001