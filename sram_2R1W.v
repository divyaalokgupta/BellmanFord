/*module************************************
*
* NAME:  sram_2R1W
*
* DESCRIPTION:   
*	Working memory: 8K*128bits, 3 Ports: 2R+1W
*  
* REVISION HISTORY
*   Date     Programmer    Description
*   2/4/13   Wenxu Zhao    Version 1.0
*    
*M*/

module SRAM_2R1W (clock, WE, WriteAddress, ReadAddress1, ReadAddress2, WriteBus, ReadBus1, ReadBus2); 
input  clock, WE; 
input  [12:0] WriteAddress, ReadAddress1, ReadAddress2; // Change as you change size of SRAM
input  [127:0] WriteBus;
output [127:0] ReadBus1;
output [127:0] ReadBus2;
 
reg [127:0] Register [0:8191];   // 8192 words, with each 128 bits wide
reg [127:0] ReadBus1;
reg [127:0] ReadBus2;
 
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
    #4 ReadBus1  =  Register[ReadAddress1];
    ReadBus2  =  Register[ReadAddress2];
  end
endmodule
