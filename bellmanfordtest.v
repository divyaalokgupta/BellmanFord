module bellmanfordtest ();

reg clock, reset;

//Graph Memory Ports
wire [12:0] GMAR1;
wire [127:0] GMDR1;
wire [12:0] GMAR2;
wire [127:0] GMDR2;

//Input Memory Ports
wire [12:0] IMAR;
wire [7:0] IMDR;

//Working Memory Ports
wire [12:0] WMAR1;
wire [12:0] WMAR2;
wire [127:0] WMDR1;
wire [127:0] WMDR2;
wire [127:0] WMWDR;
wire [12:0] WMWAR;
wire WMWE;

//Output Memory Ports
wire [12:0] OMAR;
wire [127:0] OMDR;
wire [12:0] OMWAR;
wire [127:0] OMWDR;
wire OMWE;

//Instantiating BellmanFord Module
bellmanford BellmanFord(reset, clock, GMAR1, GMDR1, GMAR2, GMDR2, IMAR, IMDR, WMAR1, WMAR2, WMDR1, WMDR2, WMWDR, WMWAR, WMWE, OMAR, OMDR, OMWAR, OMWDR, OMWE);

//Instantiating Memories
SRAM_2R GraphMemory(.ReadAddress1(GMAR1), .ReadAddress2(GMAR2), .ReadBus1(GMDR1), .ReadBus2(GMDR2));
SRAM_1R1W OutputMemory (.clock(clock), .WE(OMWE), .WriteAddress(OMWAR), .ReadAddress(OMAR), .WriteBus(OMWDR), .ReadBus(OMDR));
SRAM_1R InputMemory(.ReadAddress(IMAR), .ReadBus(IMDR));
SRAM_2R1W WorkingMemory(.clock(clock), .WE(WMWE), .WriteAddress(WMWAR), .ReadAddress1(WMAR1), .ReadAddress2(WMAR2), .WriteBus(WMWDR), .ReadBus1(WMDR1), .ReadBus2(WMDR2));

initial
	begin
	$readmemh("Graph_small_woNeg.mem",GraphMemory.Register);
	$readmemh("input_small.mem",InputMemory.Register);
	#0 reset = 1; clock = 0;
	#6 reset = 0;
	#2000 $finish;
	end

always
	#2.5 	clock = ~clock;

endmodule
