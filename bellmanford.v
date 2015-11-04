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
output wire [127:0] OMWDR;
output reg OMWE;

//State encoding
parameter [2:0] // synopsys enum states
Init    = 3'b000,
Upd_S   = 3'b001,
BFA     = 3'b010,
OP      = 3'b011,
Refresh = 3'b100,
Init1   = 3'b101,
Init2   = 3'b110,
Upd_D   = 3'b111; 

/*Boundary Flops */
reg [127:0] GMDR1_reg;
reg [127:0] GMDR2_reg;
reg [7:0] IMDR_reg;
reg [127:0] WMDR1_reg;
reg [127:0] WMDR2_reg;

always@(posedge clock)
begin
    GMDR1_reg <= GMDR1;
    GMDR2_reg <= GMDR2;
    IMDR_reg <= IMDR;
    WMDR1_reg <= WMDR1;
    WMDR2_reg <= WMDR2;
end

/* Other Registers */
reg [7:0] NumNodes;
reg [7:0] NodeCounter;
reg [7:0] Ureg;
reg [7:0] NumLinks;
reg [7:0] LinkCounter;
reg [7:0] Vreg[0:8];
reg signed [7:0] Wreg[0:8];
reg signed [7:0] NewWeight;
reg [8:0] Sub;
reg [127:0] DistU;
reg [127:0] DistV;
reg BFA_flag;

reg [2:0] /* synopsys enum states */ current_state, next_state;

/* State Transition */
always@(posedge clock)
begin
       current_state <= next_state;
end

integer i;

/* Reset Logic */
always@(posedge clock)
begin
	if(!reset)
	begin
		//Init
		GMAR1 <= 0;
		WMWAR <= 0;
		WMWE <= 0;
		//NodeCounter <= 0;
        //NumNodes <= 0;
		//Upd_SD
		IMAR <= 0;
		//BFA
		Ureg <= 0;
		NumLinks <= 0;
		LinkCounter <= 0;
		BFA_flag <= 0;
        WMAR1 <= 0;
        WMAR2 <= 0;
        NewWeight <= 0;
		for(i=1;i<=8;i= i+1)
		begin
			Vreg[i] <= 0;
			Wreg[i] <= 0;
		end
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
                    GMAR1 <= 0;
                    IMAR <= 0;      //For updating source/destination
                end
            Init1:
                begin
                end
            Init2:
                begin
    		    	NumNodes <= GMDR1_reg[63:0] - 1'b1;
    		    	NodeCounter <= GMDR1_reg[63:0] - 1'b1; //Will be overwritten in each iteration
    		    	GMAR2 <= GMDR1_reg[12:0];
    		        if(NodeCounter != 0)
    		    	    begin
    		    		    WMWAR <= WMWAR + 1'b1;
    		    		    WMWE <= 1'b1;
    		    		    WMWDR[127:107] <= 21'b100000000111111110000;
    		    		    NodeCounter <= NodeCounter - 8'b00000001;
    		    	    end
			        else
                        begin
                            IMAR <= IMAR + 1'b1;
                            WMWE <= 1'b0;
                        end
                end
    		Upd_S:
                begin
				    WMWAR <= IMDR_reg;
                    WMWDR[127] = 1'b0;
                    WMWDR[126:119] = 0;
                    WMWDR[118:111] = IMDR_reg;
                    WMWDR[110:107] <= 4'b0010;
				    WMWE <= 1'b1;
                end
            Upd_D:
                begin
				    WMWAR <= IMDR_reg;
                    WMWDR[127] = 1'b1;
                    WMWDR[126:119] = 8'h7f;
                    WMWDR[118:111] = 8'hff;
                    WMWDR[110:107] <= 4'b0001;
				    WMWE <= 1'b1;
                end
			    //if(NodeCounter == 0 && WMWDR[107] == 1'b0)
			    //begin
				//    NodeCounter <= 2'b10;
				//    WMWE <= 1'b0;
    		    //	WMWDR[127:107] <= 21'b000000000000000010010; //Repeated to facilitate state transition using only combinational circuits
			    //end
			    //else if (NodeCounter == 2'b10)
			    //begin
				//    WMWAR <= IMDR;
                //    WMWDR[127] = 1'b0;
                //    WMWDR[126:119] = 0;
                //    WMWDR[118:111] = IMDR;
                //    WMWDR[110:107] <= 4'b0010;
				//    WMWE <= 1'b1;
				//    NodeCounter <= NodeCounter - 1'b1;
				//    IMAR <= IMAR + 1'b1;                            //Get first line data from GraphMemory
                //    WMAR1 <= IMDR;                                  //Prefetching data for source node to enable faster pipeline in BFA
				//    WMAR2 <= GMDR2[111:104];   				        //WMAR2 works 2 pipeline stage before BFA step to get neccessary data
                //    Ureg <= GMDR2[127:120];
				//    Vreg[1] <= GMDR2[111:104];
				//    Wreg[1] <= GMDR2[103:96];
				//    Vreg[2] <= GMDR2[95:88];
				//    Wreg[2] <= GMDR2[87:80];
				//    Vreg[3] <= GMDR2[79:72];
				//    Wreg[3] <= GMDR2[71:64]; 
				//    Vreg[4] <= GMDR2[63:56];
				//    Wreg[4] <= GMDR2[55:48]; 
				//    Vreg[5] <= GMDR2[47:40];
				//    Wreg[5] <= GMDR2[39:32]; 
				//    Vreg[6] <= GMDR2[31:24];
				//    Wreg[6] <= GMDR2[23:16];
				//    Vreg[7] <= GMDR2[15:8];
				//    Wreg[7] <= GMDR2[7:0];
			    //end
			    //else if (NodeCounter == 2'b01)
			    //begin
			    //	WMWAR <= IMDR;
                //    WMWDR[127] <= 1'b1;
                //    WMWDR[126:119] <= 8'b00000000;
                //    WMWDR[118:111] <= 8'b11111111;
                //    WMWDR[110:107] <= 4'b0001;
			    //	WMWE <= 1'b1;
			    //	NodeCounter <= NodeCounter - 1'b1;
			    //end
			    //else
			    //begin
			    //	WMWE <= 1'b0;
			    //	WMWDR <= 0;
			    //	WMWAR <= 0;
			    //end
		        //end
    		BFA:
    		    begin
			        if(NodeCounter == 0 && BFA_flag == 0)
				        NodeCounter <= NumNodes;
			   
                    BFA_flag <= 1'b1;

			    if(NumLinks == 0)
			    begin
				    LinkCounter <= GMDR2[119:112];
				    NumLinks <= GMDR2[119:112];
                    NewWeight <= WMDR1[126:119] + Wreg[1];
			    	WMAR2 <= Vreg[2];
//				    WMAR1 <= GMDR2[127:120];
				    Sub <= 0;
				    WMWE <= 1'b0;
				    if(GMDR2[127:120] == NumNodes)
				    begin
				    	GMAR1 <= 0;
				    	NodeCounter <= NodeCounter - 1'b1;
				    end
				    else
				    	GMAR1 <= GMAR1 + 1'b1;
			    end
			    else if (Sub == 0)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > NewWeight || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[1];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= NewWeight;
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[3];
                    NewWeight <= WMDR1[126:119] + Wreg[2];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
			    else if (Sub == 1)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > NewWeight || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[2];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= NewWeight; 
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[4];
                    NewWeight <= WMDR1[126:119] + Wreg[3];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
			    else if (Sub == 2)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > NewWeight || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[5];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= NewWeight;
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[3];
                    NewWeight <= WMDR1[126:119] + Wreg[4];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
			    else if (Sub == 3)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > ($signed(WMDR1[126:119]) + Wreg[4]) || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[6];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= $signed(WMDR1[126:119]) + Wreg[4];
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[4];
                    NewWeight <= WMDR1[126:119] + Wreg[5];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
			    else if (Sub == 5)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > ($signed(WMDR1[126:119]) + Wreg[5]) || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[7];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= $signed(WMDR1[126:119]) + Wreg[5];
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[5];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
			    else if (Sub == 6)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > ($signed(WMDR1[126:119]) + Wreg[6]) || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[6];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= $signed(WMDR1[126:119]) + Wreg[6];
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[6];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
			    else if (Sub == 7)
			    begin
			    	WMWE <= 1'b0;
			    	//DistU <= WMDR1[126:119];
			    	//DistV <= WMDR2[126:119];
			    	if ($signed(WMDR2[126:119]) > ($signed(WMDR1[126:119]) + Wreg[7]) || WMDR2[127] == 1)
			    	begin
			    		WMWAR <= Vreg[7];
			    		WMWDR[127] <= 1'b0;
			    		WMWDR[126:119] <= $signed(WMDR1[126:119]) + Wreg[7];
			    		WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2[110:107];
			    		WMWE <= 1'b1;
			    	end
			    	WMAR2 <= Vreg[7];
			    	if (LinkCounter == 0)
			    	begin
			    		GMAR2 <= GMDR1_reg[12:0];
			    		NumLinks <= 0;
			    	end
			    	LinkCounter <= LinkCounter - 1'b1;
			    	Sub <= NumLinks - LinkCounter;
			    end
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
		next_state = Init;
	else if(current_state == Init)
        next_state = Init1;
    else if(current_state == Init1)
        next_state = Init2;
    else if(current_state == Init2)
	begin

//		if(NodeCounter == 0 && NumNodes == 0)
//			next_state = Init;
//		else if (NumNodes != 0 && NodeCounter == 0)
//			next_state = Upd_SD;
		if (NodeCounter == 0)
			next_state = Upd_S;
	end
	else if(current_state == Upd_S)
	begin
//		if(WMWDR[107] == 1'b1 )
//			next_state = Upd_SD;
//		else if (WMWDR[106] == 1'b1)
//			next_state = BFA;
//		if(WMWDR[107] == 1'b1 )
//			next_state = BFA;
			next_state = Upd_D;
	end
    else if(current_state == Upd_D)
            next_state = BFA;
	else if(current_state == BFA)
	begin
//		if(NodeCounter == 0 && NumLinks == 0 && LinkCounter == 0)
//			next_state = BFA;
//		else if(NodeCounter == 0 && NumLinks != 0 && LinkCounter == 0)
//			next_state = OP;
		if(BFA_flag == 1'b1 && NodeCounter == 1)
			next_state = OP;
	end
end

endmodule
/* Remove pipeline flops to and from memory ports */
/* Remove redundant if else conditions in state transition control keep only one next_state command */
/* Remove redundant flops like Vreg Wreg etc. in BFA step */
/* Start every iteration with node whose infinite bit is zero ...so need to skip over nodes whose infinite bit is high*/
/* Early Termination Condition using single flop OR */
/* check BFA with negative edge weights */
/* Start BFA with source */
