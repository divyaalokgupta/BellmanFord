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
parameter [4:0] // synopsys enum states
Init    = 4'b0000,
Init1   = 4'b0001,
Init2   = 4'b0010,
Upd_S   = 4'b0011,
Upd_D   = 4'b0100, 
BFA1    = 4'b0101,
BFA_Stall1 = 4'b0110,
BFA2    = 4'b0111,
BFA_Stall2    = 4'b1000,
BFA3    = 4'b1001,
BFA_Stall3 = 4'b1010,
BFA4    = 4'b1011,
BFA5    = 4'b1100,
BFA_Stall4 = 4'b1101,
BFA6    = 4'b1110,
OP      = 5'b10000,
Refresh = 5'b10001;

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
reg New_U_Node;

reg [3:0] /* synopsys enum states */ current_state, next_state;

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
                    IMAR <= 0;
                    WMWAR <= 0;
                end
            Init1:
                begin
                end
            Init2:
                begin
    		    	NumNodes <= GMDR1_reg[63:0] - 1'b1;
    		    	NodeCounter <= GMDR1_reg[63:0] - 1'b1; //Will be overwritten in each iteration
    		        if(NodeCounter != 0)
    		    	    begin
    		    		    WMWAR <= WMWAR + 1'b1;
    		    		    WMWE <= 1'b1;
    		    		    WMWDR[127:107] <= 21'b100000000111111110000;
    		    		    NodeCounter <= NodeCounter - 8'b00000001;
    		    	    end
			        else
                        begin
                            WMWE <= 1'b0;
                        end
                    if(NodeCounter == 0)
                        IMAR <= IMAR + 1'b1;
                end
    		Upd_S:
                begin
				    WMWAR <= IMDR_reg;
                    WMWDR[127] = 1'b0;
                    WMWDR[126:119] = 0;
                    WMWDR[118:111] = IMDR_reg;
                    WMWDR[110:107] <= 4'b0010;
				    WMWE <= 1'b1;
				    WMAR1 <= IMDR_reg;                                      //Get 1st source node data data from Working Memory
                    NumLinks <= 0;
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
                end
            BFA1:
                begin
                    IMAR <= 0;                                              //Look for 1st pair of source and destination pairs
                    WMWE <= 1'b0;
                    New_U_Node <= 0;
                end
            BFA_Stall1:
                begin
                end
            BFA2:
                begin
                    casex(New_U_Node)
                        0:
                            begin
                                Ureg <= IMDR_reg;
                                WMAR1 <= IMDR_reg;                                             //Get source node data from WM
                                GMAR1 <= IMDR_reg - 1'b1;                                      //Look for source node's daughters
                            end
                        1:
                            begin
                                if(GMDR2_reg[127:120] == 0)
                                    begin
                                        Ureg <= GMDR1_reg[71:64];
                                        WMAR1 <= GMDR1_reg[71:64];                               //Get new U node's data from WM
                                        NodeCounter <= NodeCounter - 1'b1;
                                        New_U_Node <= 1'b0;
                                    end
                                else
                                    begin
                                        Ureg <= GMDR2_reg[127:120];
                                        WMAR1 <= GMDR2_reg[127:120];                           //Get new U node's data from WM
                                    end
                            end
                    endcase
                end
            BFA_Stall2:
                begin
                end
            BFA3:
                begin
                    if(New_U_Node == 0)
                        GMAR2 <= GMDR1_reg[12:0];
                end
            BFA_Stall3:
                begin
                end
            BFA4:
                begin
                    DistU <= WMDR1_reg[126:119];
                    NumLinks <= GMDR2_reg[119:112];
                    if(GMDR2_reg[119:112] < 7)
                        LinkCounter <= GMDR2_reg[119:112];
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
                    Sub <= 0;
                end
            BFA5:
                begin
                    WMWE <= 1'b0;
                    New_U_Node <= 1'b0;
                    if(LinkCounter == 0)
                    begin
                       GMAR2 <= GMAR2 + 1'b1;
                       New_U_Node <= 1'b1;
                    end
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
                   if(WMDR2_reg[126:119] > NewWeight || WMDR2_reg[127] == 1)
                    begin
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
                        WMWE <= 1'b1;
                   end
                   LinkCounter <= LinkCounter - 1'b1;
                   Sub <= Sub + 1'b1;
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
			next_state = Upd_S;
	end
	else if(current_state == Upd_S)
			next_state = Upd_D;
    else if(current_state == Upd_D)
            next_state = BFA1;
	else if(current_state == BFA1)
            next_state = BFA_Stall1;
    else if(current_state == BFA_Stall1)
            next_state = BFA2;
	else if(current_state == BFA2)
            next_state = BFA_Stall2;
	else if(current_state == BFA_Stall2)
            next_state = BFA3;
	else if(current_state == BFA3)
            next_state = BFA_Stall3;
	else if(current_state == BFA_Stall3)
            next_state = BFA4;
	else if(current_state == BFA4)
            next_state = BFA5;
	else if(current_state == BFA5)
    begin
        if(LinkCounter == 0)
            next_state = BFA_Stall1;
        else
            next_state = BFA_Stall4;
    end
	else if(current_state == BFA_Stall4)
            next_state = BFA6;
	else if(current_state == BFA6)
            next_state = BFA5;
end
endmodule
/* Start every iteration with node whose infinite bit is zero ...so need to skip over nodes whose infinite bit is high*/
/* Early Termination Condition using single flop OR */
/* check BFA with negative edge weights */
/* Start BFA with source */
