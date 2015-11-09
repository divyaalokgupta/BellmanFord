module bellmanfordtest4 ();

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
wire [15:0] OMDR;
wire [12:0] OMWAR;
wire [15:0] OMWDR;
wire OMWE;
wire NegCycle;
wire Finish;

integer out;

//Instantiating BellmanFord Module
bellmanford BellmanFord(reset, clock, GMAR1, GMDR1, GMAR2, GMDR2, IMAR, IMDR, WMAR1, WMAR2, WMDR1, WMDR2, WMWDR, WMWAR, WMWE, OMAR, OMDR, OMWAR, OMWDR, OMWE, NegCycle, Finish);

//Instantiating Memories
SRAM_2R GraphMemory(.ReadAddress1(GMAR1), .ReadAddress2(GMAR2), .ReadBus1(GMDR1), .ReadBus2(GMDR2));
SRAM_1R1W OutputMemory (.clock(clock), .WE(OMWE), .WriteAddress(OMWAR), .ReadAddress(OMAR), .WriteBus(OMWDR), .ReadBus(OMDR));
SRAM_1R InputMemory(.ReadAddress(IMAR), .ReadBus(IMDR));
SRAM_2R1W WorkingMemory(.clock(clock), .WE(WMWE), .WriteAddress(WMWAR), .ReadAddress1(WMAR1), .ReadAddress2(WMAR2), .WriteBus(WMWDR), .ReadBus1(WMDR1), .ReadBus2(WMDR2));

integer i, output_file;
initial
	begin
        $monitor ("TIME = %g RESET = %b CLOCK = %b NegCycle = %b Finish = %b ", $time, reset, clock, NegCycle, Finish);
        output_file = $fopen("MyOutput_large_woNeg.dat","w");
	    $readmemh("Graph_large_woNeg.mem",GraphMemory.Register);
	    $readmemh("Input_large.dat",InputMemory.Register);
	    #0 reset = 1; clock = 0;
	    #6 reset = 0;
    end

    always@ (Finish)
    begin
	    for (i = 0; i < 8192; i = i + 1)
            begin
                if(OutputMemory.Register[i] == 16'hffff)
            		$fwrite(output_file,"%H\n",16'hFFFF);
                else
            		$fwrite(output_file,"%d\n", OutputMemory.Register[i]);
	    end
        $writememh("MyOutput_large_woNeg.mem",OutputMemory.Register);
        $finish;
    end

    always@(NegCycle)
    begin
            $fwrite(output_file,"Negative cycle exists");
            $fclose(output_file);
            $finish;
    end

always
	#5 	clock = ~clock;

endmodule
