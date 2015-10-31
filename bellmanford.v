module bellmanford (reset, clock, GMAR1, GMDR1, GMAR2, GMDR2, IMAR, IMDR, WMAR1, WMAR2, WMDR1, WMDR2, WMWDR, WMWAR, WMWE, OMAR, OMDR, OMWAR, OMWDR, OMWE);

input clock,reset;

//Graph Memory Ports
output reg [12:0] GMAR1;
input wire [127:0] GMDR1;
output reg [12:0] GMAR2;
input wire [127:0] GMDR2;

//Input Memory Ports
output reg [12:0] IMAR;
input wire [7:0] IMDR;

//Working Memory Ports
output reg [12:0] WMAR1;
input wire [127:0] WMDR1;
output reg [12:0] WMAR2;
input wire [127:0] WMDR2;
output reg [12:0] WMWAR;
output reg [127:0] WMWDR;
output reg WMWE;

//Output Memory Ports
output reg [12:0] OMAR;
output reg [127:0] OMDR;
output reg [12:0] OMWAR;
input wire [127:0] OMWDR;
output reg OMWE;

//State encoding
parameter [2:0] // synopsys enum states
Init    = 3'b000,
Upd_SD  = 3'b001,
BFA     = 3'b010,
OP      = 3'b011,
Refresh = 3'b100;

/* Other Registers */
reg [7:0] NumNodes;
reg [7:0] NodeCounter;

reg [2:0] /* synopsys enum states */ current_state, next_state;

/* State Transition */
always@(posedge clock)
begin
       if(reset)
           current_state <= Init;
       else
           current_state <= next_state;
end

/* Reset State */
always@(posedge clock)
begin
	if(reset)
	begin
		//Init
		GMAR1 <= 0;
		WMWAR <= 0;
		WMWE <= 0;
		NumNodes <= 0;
		NodeCounter <= 0;
		//Upd_SD
		IMAR <= 0;
	end
end

/* Sequential Logic */
always@(posedge clock)
begin
	if(!reset)
	begin
    		casex(current_state)
    		Init:
    		    begin
    		    	if(NumNodes == 0)
    		    	begin
    		    		NumNodes <= GMDR1[63:0] - 1'b1;
    		    		NodeCounter <= GMDR1[63:0] - 1'b1;
    		    		GMAR2 <= GMDR1[12:0];
    		    	end
    		    	else if(NumNodes !=0 && NodeCounter != 0)
    		    	begin
    		    		WMWAR <= WMWAR + 1'b1;
    		    		WMWE <= 1'b1;
    		    		WMWDR[127:107] <= 21'b100000000111111110000;
    		    		NodeCounter <= NodeCounter - 8'b00000001;
    		    	end
			else
				WMWE <= 1'b0;
    		    end
    		Upd_SD:
    		    begin
			if(NodeCounter == 0 && WMWDR[107] == 1'b0)
			begin
				NodeCounter <= 2'b10;
				WMWE <= 1'b0;
    		    		WMWDR[127:107] <= 21'b100000000111111110010; //Repeated to facilitate state transition using only combinational circuits
			end
			else if (NodeCounter == 2'b10)
			begin
				WMWAR <= IMDR;
    		    		WMWDR[127:107] <= 21'b100000000111111110010;
				WMWE <= 1'b1;
				NodeCounter = NodeCounter - 1'b1;
			end
			else if (NodeCounter == 2'b01)
			begin
				WMWAR <= IMDR;
    		    		WMWDR[127:107] <= 21'b100000000111111110001;
				WMWE <= 1'b1;
				NodeCounter = NodeCounter - 1'b1;
			end
			else
			begin
				WMWE <= 1'b0;
				WMWDR <= 0;
				WMWAR <= 0;
			end
		    end
    		BFA:
    		    begin
    		    end
    		OP:
    		    begin
    		    end
    		Refresh:
    		    begin
    		    end

    		endcase
	end
end

/*State Transition Control*/
always@(*)
begin
	if(reset)
		next_state <= Init;
	else if(current_state == Init)
	begin
		if(NodeCounter == 0 && NumNodes == 0)
			next_state = Init;
		else if (NumNodes != 0 && NodeCounter == 0)
			next_state = Upd_SD;
	end
	else if(current_state == Upd_SD)
	begin
		if(WMWDR[108] == 1'b1 )
			next_state = Upd_SD;
		else if (WMWDR[107] == 1'b1)
			next_state = BFA;
	end
end

endmodule
/* Remove pipeline flops to and from memory ports */
