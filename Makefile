.PHONY: bench
bench:
	ls -al
	cd ./trace
	wget http://data.tarides.com/irmin/lru.trace
	cd ..
	opam exec -- dune exec -- bench/replay.exe lru 5001