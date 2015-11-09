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
	@vlog bellmanfordtest4.v
	@vlog bellmanfordtest5.v
	@vlog bellmanfordtest6.v
	@vlog bellmanfordtest7.v

sim1: bellmanford
	vsim -batch -novopt -logfile sim1.log -do bellmanfordtest1.do bellmanfordtest1

sim1g: bellmanford
	vsim -i -novopt -logfile sim1.log -do bellmanfordtest1.do bellmanfordtest1 &

sim2: bellmanford
	vsim -batch -novopt -logfile sim2.log -do bellmanfordtest2.do bellmanfordtest2

sim3: bellmanford
	vsim -batch -novopt -logfile sim3.log -do bellmanfordtest3.do bellmanfordtest3

sim4: bellmanford
	vsim -batch -novopt -logfile sim4.log -do bellmanfordtest4.do bellmanfordtest4

sim5: bellmanford
	vsim -batch -novopt -logfile sim5.log -do bellmanfordtest5.do bellmanfordtest5

sim6: bellmanford
	vsim -batch -novopt -logfile sim6.log -do bellmanfordtest6.do bellmanfordtest6

sim7: bellmanford
	vsim -batch -novopt -logfile sim7.log -do bellmanfordtest7.do bellmanfordtest7

test:
	@make sim1
	@make sim2
	@make sim3
	@make sim5
	@make sim6

clean:
	rm -f bellmanford.out setup MyOutput* ./test/*/MyOutput* *.log
