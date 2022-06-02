.PHONY: bench
bench:
	sudo apt-get install wget
	wget --directory-prefix=./trace http://data.tarides.com/irmin/lru.trace
	# for i in $(shell seq 5000 1000 20000);  do echo $$i; opam exec -- dune exec -- bench/replay.exe lru $$i; done
	opam exec -- dune exec -- bench/replay.exe lru 5000
	opam exec -- dune exec -- bench/replay.exe lfu 5000