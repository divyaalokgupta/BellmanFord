module bellmanford (reset, clock, GMAR1, GMDR1, GMAR2, GMDR2, IMAR, IMDR, WMAR1, WMAR2, WMDR1, WMDR2, WMWDR, WMWAR, WMWE, OMAR, OMDR, OMWAR, OMWDR, OMWE, NegCycle, Finish);

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
output reg [15:0] OMDR;
output reg [12:0] OMWAR;
output reg [15:0] OMWDR;
output reg OMWE;

//Output Port
output reg NegCycle;
output reg Finish;

//State encoding
parameter [4:0] // synopsys enum states
Init    = 4'b0000,
Init1   = 4'b0001,
Init2   = 4'b0010,
Init3   = 4'b0011,
Upd_S   = 4'b0100,
Upd_D   = 4'b0101, 
BFA1    = 4'b0110,
BFA_Stall1 = 4'b0111,
BFA2    = 4'b1000,
BFA_Stall2    = 4'b1001,
BFA3    = 4'b1010,
BFA_Stall3 = 4'b1011,
BFA4    = 4'b1100,
BFA5    = 4'b1101,
BFA_Stall4 = 4'b1110,
BFA6    = 4'b1111,
OP1     = 5'b10000,
OP_Stall1 = 5'b10001,
OP2     = 5'b10010,
OP3     = 5'b10011,
OP4     = 5'b10100,
OP_Stall2 = 5'b10101,
Refresh1 = 5'b10110,
Refresh2 = 5'b10111,
End1 = 5'b11000,
End2 = 5'b11001,
End3 = 5'b11010;

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
reg [7:0] Sub;
reg BFA_flag;
reg signed [7:0] DistU;
reg First_Node;
reg NegativeCycleCheck;
reg FirstLine;
reg MultiLine;

reg [4:0] /* synopsys enum states */ current_state, next_state;

/* State Transition */
always@(posedge clock)
begin
       current_state <= next_state;
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
                    GMAR2 <= 0;
                    IMAR <= 0;
                    WMWAR <= 0;
                    OMWAR <= 13'h1fff;
                    NodeCounter <= 8'h81;
                end
            Init1:
                begin
                end
            Init2:
                begin
                    GMAR1 <= GMAR1 + 1'b1;
                    if (NodeCounter == 8'h81)
                        begin
                            NumNodes <= GMDR1_reg[63:0] - 1'b1;
                            NodeCounter <= GMDR1_reg[7:0] - 2'b10;
    		    		    WMWAR <= WMWAR + 1'b1;
    		    		    WMWE <= 1'b1;
    		    		    WMWDR[127:107] <= 21'b100000000111111110000;
                            WMWDR[106:94] <= GMDR1_reg[12:0];
                        end
    		        else if(NodeCounter != 0)
    		    	    begin
    		    		    WMWAR <= WMWAR + 1'b1;
    		    		    WMWE <= 1'b1;
    		    		    WMWDR[127:107] <= 21'b100000000111111110000;
                            WMWDR[106:94] <= GMDR1_reg[12:0];
    		    		    NodeCounter <= NodeCounter - 8'b00000001;
    		    	    end
			        else
                        begin
                            WMWE <= 1'b0;
                            GMAR1 <= IMDR_reg - 1'b1;
                        end
                end
            Init3:
                begin
                     NodeCounter <= NumNodes;
                     IMAR <= IMAR + 1'b1;
                     OMWE <= 1'b0;
                     WMWE <= 1'b0;
                     GMAR1 <= IMAR + 1'b1;
                end
    		Upd_S:
                begin
				    WMWAR <= IMDR_reg;
                    WMWDR[127] = 1'b0;
                    WMWDR[126:119] = 0;
                    WMWDR[118:111] = IMDR_reg;
                    WMWDR[110:107] <= 4'b0010;
				    WMWE <= 1'b1;
				    WMAR1 <= IMDR_reg;                                      //Get 1st source node data from Working Memory
                    NumLinks <= 0;
                    WMWDR[106:94] <= GMDR1_reg[12:0];
                end
            Upd_D:
                begin
				    WMWAR <= IMDR_reg;
                    WMWDR[127] = 1'b1;
                    WMWDR[126:119] = 8'h00;
                    WMWDR[118:111] = 8'hff;
                    WMWDR[110:107] <= 4'b0001;
				    WMWE <= 1'b1;
			    	WMAR2 <= GMDR2_reg[111:104];
                    WMWDR[106:94] <= GMDR1_reg[12:0];
                end
            BFA1:
                begin
                    IMAR <= IMAR - 1'b1;                                              //Look for 1st pair of source and destination pairs
                    WMWE <= 1'b0;
                    First_Node <= 0;
                    NegativeCycleCheck <= 0;
                end
            BFA_Stall1:
                begin
                end
            BFA2:
                begin
                    FirstLine <= 1'b1;
                    casex(First_Node)
                        0:
                            begin
                                Ureg <= IMDR_reg;
                                NegativeCycleCheck <= 1'b1;
                                WMAR1 <= IMDR_reg;                                             //Get source node data from WM
                                GMAR1 <= IMDR_reg - 1'b1;                                      //Look for source node's daughters
                                IMAR <= IMAR + 1'b1;
                            end
                        1:
                            begin
                                if(GMDR2_reg[127:120] == 0)
                                    begin
                                        NegativeCycleCheck <= 1'b0;
                                        Ureg <= GMDR1_reg[71:64];
                                        WMAR1 <= GMDR1_reg[71:64];                               //Get new U node's data from WM
                                        NodeCounter <= NodeCounter - 1'b1;
                                        GMAR2 <= GMDR1_reg[71:64] - 1'b1;
                                    end
                                else if(WMDR1_reg[127] == 1'b0)
                                    begin
                                        Ureg <= WMAR1[7:0];
                                        GMAR2 <= WMAR1 - 1'b1;                           //Get new U node's data from WM
                                    end
                                else if (WMDR1_reg[127] == 1'b1)
                                    begin
                                        if(WMAR1[7:0] == NumNodes)
                                            WMAR1 <= 0;
                                        else
                                            WMAR1 <= WMAR1 + 1'b1;
                                    end
                            end
                    endcase
                end
            BFA_Stall2:
                begin
                end
            BFA3:
                begin
                    GMAR1 <= 0;
                    if(First_Node == 1'b0)
                        GMAR2 <= GMDR1_reg[12:0];
                    else if (First_Node == 1'b1 && WMDR1_reg[127] == 1'b0)
                        GMAR2 <= GMDR2_reg[12:0];
                end
            BFA_Stall3:
                begin
                end
            BFA4:
                begin
                    if(FirstLine == 1'b1)
                        begin
                            DistU <= WMDR1_reg[126:119];
                            NumLinks <= GMDR2_reg[119:112];
                            if(GMDR2_reg[119:112] < 7)
                                begin
                                    MultiLine <= 1'b0;
                                    LinkCounter <= GMDR2_reg[119:112];
                                end
                            else
                                begin
                                    LinkCounter <= 7;
                                    MultiLine <= 1'b1;
                                end
				            Vreg[1] <= GMDR2_reg[111:104];
				            Wreg[1] <= GMDR2_reg[103:96];
				            Vreg[2] <= GMDR2_reg[95:88];
				            Wreg[2] <= GMDR2_reg[87:80];
				            Vreg[3] <= GMDR2_reg[79:72];
				            Wreg[3] <= GMDR2_reg[71:64]; 
				            Vreg[4] <= GMDR2_reg[63:56];
				            Wreg[4] <= GMDR2_reg[55:48]; 
				            Vreg[5] <= GMDR2_reg[47:40];
				            Wreg[5] <= GMDR2_reg[39:32]; 
				            Vreg[6] <= GMDR2_reg[31:24];
				            Wreg[6] <= GMDR2_reg[23:16];
				            Vreg[7] <= GMDR2_reg[15:8];
				            Wreg[7] <= GMDR2_reg[7:0];
                            Vreg[8] <= 0;
                            Wreg[8] <= 0;
                        end
                    else
                        begin
                            if(NumLinks > 8)
                                begin
                                    MultiLine <= 1'b1;
                                    LinkCounter <= 8;
                                end
                            else
                                begin
                                    MultiLine <= 1'b0;
                                    LinkCounter <= NumLinks;
                                end
                            Vreg[1] <= GMDR2_reg[127:120];
                            Wreg[1] <= GMDR2_reg[119:112];
				            Vreg[2] <= GMDR2_reg[111:104];
				            Wreg[2] <= GMDR2_reg[103:96];
				            Vreg[3] <= GMDR2_reg[95:88];
				            Wreg[3] <= GMDR2_reg[87:80];
				            Vreg[4] <= GMDR2_reg[79:72];
				            Wreg[4] <= GMDR2_reg[71:64]; 
				            Vreg[5] <= GMDR2_reg[63:56];
				            Wreg[5] <= GMDR2_reg[55:48]; 
				            Vreg[6] <= GMDR2_reg[47:40];
				            Wreg[6] <= GMDR2_reg[39:32]; 
				            Vreg[7] <= GMDR2_reg[31:24];
				            Wreg[7] <= GMDR2_reg[23:16];
				            Vreg[8] <= GMDR2_reg[15:8];
				            Wreg[8] <= GMDR2_reg[7:0];
                        end
                    Sub <= 0;
                end
            BFA5:
                begin
                    WMWE <= 1'b0;
                    
                    if(WMDR1_reg[127] == 1'b1)
                    begin
                        NumLinks <= 0;
                        LinkCounter <= 0;
                    end
                    
                    if (NumLinks == 0)
                    begin
                       First_Node <= 1'b1;
                    end

                    if(LinkCounter == 0 )
                    begin
                       FirstLine <= 1'b0;
                       GMAR2 <= GMAR2 + 1'b1;
                    end

                    if(NumLinks == 0 && LinkCounter == 0)
                        WMAR1 <= WMAR1 + 1'b1;

                    case(Sub)
                        0: 
                            begin
                                WMAR2 <= Vreg[1];
                                NewWeight <= DistU + Wreg[1];
                            end
                        1: 
                            begin
                                WMAR2 <= Vreg[2];  
                                NewWeight <= DistU + Wreg[2];
                            end
                        2:  
                            begin
                                WMAR2 <= Vreg[3];  
                                NewWeight <= DistU + Wreg[3];
                            end
                        3:  
                            begin
                                WMAR2 <= Vreg[4];  
                                NewWeight <= DistU + Wreg[4];
                            end
                        4:  
                            begin
                                WMAR2 <= Vreg[5];  
                                NewWeight <= DistU + Wreg[5];
                            end
                        5:  
                            begin
                                WMAR2 <= Vreg[6];  
                                NewWeight <= DistU + Wreg[6];
                            end
                        6:  
                            begin
                                WMAR2 <= Vreg[7];  
                                NewWeight <= DistU + Wreg[7];
                            end
                        7:  
                            begin
                                WMAR2 <= Vreg[8];  
                                NewWeight <= DistU + Wreg[8];
                            end
                    endcase
                end
            BFA_Stall4:
                begin
                end
            BFA6:
                begin
                   if($signed(WMDR2_reg[126:119]) > NewWeight || WMDR2_reg[127] == 1)
                    begin
                        NegativeCycleCheck <= 1'b1;
                        casex(Sub)
                            0:  begin
                                    WMWAR <= Vreg[1]; 
                                end
                            1:  begin
                                    WMWAR <= Vreg[2]; 
                                end
                            2:  begin 
                                    WMWAR <= Vreg[3]; 
                                end
                            3:  begin 
                                    WMWAR <= Vreg[4]; 
                                end
                            4:  begin 
                                    WMWAR <= Vreg[5]; 
                                end
                            5:  begin 
                                    WMWAR <= Vreg[6]; 
                                end
                            6:  begin 
                                    WMWAR <= Vreg[7]; 
                                end
                            7:  begin 
                                    WMWAR <= Vreg[8]; 
                                end
                        endcase
                        WMWDR[127] = 1'b0;
                        WMWDR[126:119] <= NewWeight;
                        WMWDR[118:111] <= Ureg;
                        WMWDR[110:107] <= WMDR2_reg[110:107];
                        WMWDR[106:94] <= WMDR2_reg[106:94];
                        WMWE <= 1'b1;
                   end
                   LinkCounter <= LinkCounter - 1'b1;
                   NumLinks <= NumLinks - 1'b1;
                   Sub <= Sub + 1'b1;
                end
            OP1:
                begin
                    WMAR2 <= IMDR_reg;
                end
            OP_Stall1:
                begin
                end
            OP2:
                begin
                    OMWAR <= OMWAR + 1'b1;
                    OMWDR <= WMDR2_reg[126:119];
                    OMWE <= 1'b1;
                    WMAR2 <= WMDR2_reg[118:111];
                end
            OP3:
                begin
                    OMWAR <= OMWAR + 1'b1;
                    OMWDR <= IMDR_reg;
                    OMWE <= 1'b1;
                    IMAR <= IMAR + 1'b1;
                end
            OP4:
                begin
                    OMWDR <= WMAR2;
                    OMWE <= 1'b1;
                    OMWAR <= OMWAR + 1'b1;
                    WMAR2 <= WMDR2_reg[118:111];
                    WMAR1 <= NumNodes;
                end
            OP_Stall2:
                begin
                    OMWE <= 1'b0;
                end
            End1:
                begin
                    if(IMDR_reg == 8'hff)
                    begin
                        NodeCounter <= NumNodes;
                        OMWDR <= 16'hFFFF;
                        OMWE <= 1'b1;
                        OMWAR <= OMWAR + 1'b1;

                    end
                    else
                    begin
                        OMWDR <= 8'h0;
                        OMWE <= 1'b1;
                        OMWAR <= OMWAR + 1'b1;
                    end
                end
            Refresh1:
                begin
                    OMWE <= 1'b0;
                    WMWAR <= NumNodes;
                    WMWDR[127:107] <= 21'b100000000111111110000;
                    WMWDR[106:94] <= WMDR1_reg[104:96];
                    WMWE <= 1'b1;
                    IMAR <= IMAR + 1'b1;
                end
            Refresh2:
                begin
                    WMWAR <= WMWAR - 1'b1;
                    WMWDR[127:107] <= 21'b100000000111111110000;
                    WMWE <= 1'b1;
                end
            End2:
                begin
                    OMWE <= 1'b0;
                    WMWE <= 1'b0;
                    Finish <= 1'b1; 
                end
            End3:
                begin
                    NegCycle <= 1'b1; 
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
		if (NodeCounter == 0)
			next_state = Init3;
        else
            next_state <= Init1;
	end
	else if(current_state == Init3)
			next_state = Upd_S;
	else if(current_state == Upd_S)
			next_state = Upd_D;
    else if(current_state == Upd_D)
            next_state = BFA1;
	else if(current_state == BFA1)
            next_state = BFA_Stall1;
    else if(current_state == BFA_Stall1)
            next_state = BFA2;
	else if(current_state == BFA2)
    begin
        if (WMDR1_reg[127] == 1'b1)
            next_state = BFA_Stall1;
        else if(First_Node == 1)
        begin
            if ((NegativeCycleCheck == 1'b0) && GMDR2_reg[127:120] == 8'h00 )
                next_state = OP1;
//            else if((NodeCounter == 8'h02) && (NegativeCycleCheck == 1'b1))
//                next_state = BFA_Stall3;
            else if((NodeCounter == 8'h01) && (NegativeCycleCheck == 1'b0) && GMDR2_reg[127:120] == 8'h00)
                next_state = OP1;
            else if((NodeCounter == 8'h01) && (NegativeCycleCheck == 1'b1))
                next_state = End3;
            else
                next_state = BFA_Stall2;
            end
        else if (WMDR1_reg[127] == 1'b0 && First_Node == 1'b0)
            next_state = BFA_Stall2;
        else if (WMDR1_reg[127] == 1'b1)
            next_state = BFA_Stall1;
        else
            next_state = BFA_Stall2;
    end
	else if(current_state == BFA_Stall2)
            next_state = BFA3;
	else if(current_state == BFA3)
    begin
        if(WMDR1_reg[127] == 1'b1)
            next_state = BFA2;
        else
            next_state = BFA_Stall3;
    end
	else if(current_state == BFA_Stall3)
    begin
        if(WMDR1_reg[127] == 1'b1)
            next_state = BFA5;
        else
            next_state = BFA4;
    end
	else if(current_state == BFA4)
            next_state = BFA5;
	else if(current_state == BFA5)
    begin
        if (WMDR1_reg[127] == 1'b1)
            next_state = BFA_Stall1;
        else if(NumLinks == 0 && LinkCounter == 0)
            next_state = BFA_Stall1;
        else if (NumLinks != 0 && LinkCounter == 0)
            next_state = BFA_Stall3;
        else
            next_state = BFA_Stall4;
    end
	else if(current_state == BFA_Stall4)
            next_state = BFA6;
	else if(current_state == BFA6)
            next_state = BFA5;
    else if(current_state == OP1)
            next_state = OP_Stall1;
    else if(current_state == OP_Stall1)
            next_state = OP2;
    else if(current_state == OP2)
            next_state = OP3;
    else if(current_state == OP3)
            next_state = OP4;
    else if(current_state == OP4)
        begin
            if(WMDR2_reg[108] == 1'b1)
                next_state = End1;
            else
                next_state = OP_Stall2;
        end
    else if(current_state == OP_Stall2)
            next_state = OP4;
    else if(current_state == Refresh1)
        next_state = Refresh2;
    else if(current_state == Refresh2)
        begin
            if(WMWAR == 0)
                next_state = Init3;
            else
                next_state = Refresh2;
        end
    else if(current_state == End1)
        begin
            if(IMDR_reg == 8'hFF)
                next_state = Refresh1;
            else
                next_state = End2;
        end
end
endmodule
