.PHONY: bench
bench:
	sudo apt-get install wget
	wget --directory-prefix=./trace http://data.tarides.com/irmin/lru.trace
	for i in $(shell seq 1 2); do opam exec -- dune exec -- bench/replay.exe lru 10001; done