etup:
	@vlib mti_lib
	@vlib work
	@touch $@

bellmanford: setup
	@gcc -g -Wall -O0 bellmanford.c -o bellmanford.out -lm
	@vlog sram_1R.updated.v
	@vlog sram_1R1W.updated.v
	@vlog sram_2R1W.updated.v
	@vlog sram_2R.updated.v
	@vlog bellmanford.v
	@vlog bellmanfordtest.v

sim:
	vsim -i -novopt bellmanfordtest &

clean:
	rm -f bellmanford.out setup
