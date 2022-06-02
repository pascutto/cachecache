.PHONY: bench
bench:
	sudo apt-get install wget
	wget --directory-prefix=./trace http://data.tarides.com/irmin/lru.trace
	dune exec bench/replay.exe 