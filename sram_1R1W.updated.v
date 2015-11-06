/*module************************************
*
* NAME:  sram_1R1W
*
* DESCRIPTION:   
*	Output Buffer: 16K*16bits, 2 Ports: 1R+1W
*  
* REVISION HISTORY
*   Date     Programmer    Description
*   2/4/13   Wenxu Zhao    Version 1.0
*    
*M*/

module SRAM_1R1W (clock, WE, WriteAddress, ReadAddress, WriteBus, ReadBus);
input  clock, WE; 
input  [12:0] WriteAddress, ReadAddress; // Change as you change size of SRAM
input  [7:0] WriteBus;
output [7:0] ReadBus;

reg [7:0] Register [0:8191];   // 16384 words, with each 16 bits wide
reg [7:0] ReadBus;

// provide one write enable line per register
reg [8191:0] WElines;
integer i;

// Write '1' into write enable line for selected register
// Note the 4 ns delay - THIS IS THE INPUT DELAY FOR THE MEMORY FOR SYNTHESIS
always@(*)
#4 WElines = (WE << WriteAddress);

always@(posedge clock)
    for (i=0; i<=8191; i=i+1)
      if (WElines[i]) Register[i] <= WriteBus;

// Note the 4 ns delay - this is the OUTPUT DELAY FOR THE MEMORY FOR SYNTHESIS
always@(*) 
  begin 
    #4 ReadBus  =  Register[ReadAddress];
  end endmodule
