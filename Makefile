.PHONY: bench
bench:
	sudo apt-get install wget
	wget --version
	ls -al
	wget http://data.tarides.com/irmin/lru.trace -O ./trace/lru.trace
	opam exec -- dune exec -- bench/replay.exe lru 5001