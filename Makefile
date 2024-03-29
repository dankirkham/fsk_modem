.PHONY: sim
sim:
	cargo run --release --bin sim

.PHONY: synth
synth:
	cargo run --bin synth

.PHONY: program
program:
	dfu-util -D firmware/dds/top.bin

.PHONY: quartus
quartus:
	scp -i ~/.ssh/quartus-debian firmware/dds/top.v 192.168.0.119:/home/dan/Projects/fsk_modem

.PHONY: docs
docs:
	cd docs/ && make clean && make
	cp docs/build/fsk.pdf fsk_modem.pdf

