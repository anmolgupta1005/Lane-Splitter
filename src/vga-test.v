`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Anmol Gupta, MS-CE
//
// Create Date:   00:53:02 12/12/2015
// Design Name:   vga_display
// Module Name:   X:/Documents/VGA_Controlller/vga-test.v
// Project Name:  Rush Hour
// Target Device:  The Nexys3 is a complete, ready to Xilinx Spartan6 LX16 FPGA
// Tool versions:  
// Description: Test bench for the VGA-controller
//
// Verilog Test Fixture created by ISE for module: vga_display
//
// Dependencies: vga_controller.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vga_test;

	// Inputs
	reg rst;
	reg clk;

	// Outputs
	wire [2:0] R;
	wire [2:0] G;
	wire [1:0] B;
	wire HS;
	wire VS;

	// Instantiate the Unit Under Test (UUT)
	vga_display uut (
		.rst(rst), 
		.clk(clk), 
		.R(R), 
		.G(G), 
		.B(B), 
		.HS(HS), 
		.VS(VS)
	);
	
	always begin
	#10 clk=~clk;
	end

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

