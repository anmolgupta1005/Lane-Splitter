`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Anmol Gupta, MS-CE
// 
// Create Date:    06:21:31 12/16/2015 
// Design Name: 
// Module Name:    clock_divison 
// Project Name: Rush Hour
// Target Devices: The Nexys3 is a complete, ready to Xilinx Spartan6 LX16 FPGA
// Tool versions: 
// Description: The snippet generates a 1Hz clock using the 25MHz clock using clock 
//				division
// Dependencies:
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock_divison( clk, clk_25Mhz, clk_1hz
    );

	// parameter for clock division
	parameter N = 2;	
	parameter [31:0] Divisor=32'd100_000_000;
	
	// Defining the input and output signals 
	input clk;
	output reg clk_25Mhz=0, clk_1hz=0;
	reg [N-1:0] count;
	reg [31:0] value=0;
	
	// generatring 25Mhz clk
	always @ (posedge clk) begin
		count <= count + 1'b1;
		clk_25Mhz <= count[N-1];
	end
	
	
	// generating 1Hz clk
	always @ (posedge clk)
	begin
		value = value + 32'd1;
		  if(value == (Divisor/2))
        begin
            clk_1hz = ~clk_1hz;
            value = 0;
        end
   end
endmodule
