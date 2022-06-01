.PHONY: bench
bench:
	sudo apt-get install wget
	wget --directory-prefix=./trace http://data.tarides.com/irmin/lru.trace
	for i in $(shell seq 1 100); do opam exec -- dune exec -- bench/replay.exe lru 5001; done