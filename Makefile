setup:
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
	@vlog bellmanfordtest1.v
	@vlog bellmanfordtest2.v
	@vlog bellmanfordtest3.v

sim1: bellmanford
	vsim -batch -novopt -do bellmanfordtest1.do bellmanfordtest1

sim2: bellmanford
	vsim -batch -novopt -do bellmanfordtest2.do bellmanfordtest2

sim3: bellmanford
	vsim -batch -novopt -do bellmanfordtest3.do bellmanfordtest3

clean:
	rm -f bellmanford.out setup
