/*module************************************
*
* NAME:  sram_1R
*
* DESCRIPTION:   
*	Input Buffer: 1024*8bits, 1 read port
*  
* REVISION HISTORY
*   Date     Programmer    Description
*   2/4/13   Wenxu Zhao    Version 1.0
*    
*M*/

module SRAM_1R (ReadAddress, ReadBus);
input  [12:0] ReadAddress; // Change as you change size of SRAM
output [7:0] ReadBus;

reg [7:0] Register [0:1023];   // 1024 words, with each 8 bits wide
reg [7:0] ReadBus;

// Note the 4 ns delay - this is the OUTPUT DELAY FOR THE MEMORY FOR SYNTHESIS
always@(*)
  begin 
    #4 ReadBus  =  Register[ReadAddress];
  end
endmodule
