`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Anmol Gupta, MS-CE
// 
// Create Date:    06:32:54 12/16/2015 
// Design Name: 
// Module Name:    speed_control 
// Project Name: Lane Splitter
// Target Devices: The Nexys3 is a complete, ready to Xilinx Spartan6 LX16 FPGA
// Tool versions: 
// Description: The snippet of code controls the speed of the counter. To this end
//				it determines the speed of incoming cars
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module speed_control( clk, rst, start_game, speed
    );
	input clk;
	input rst;
	input start_game;
	output reg [19:0] speed=20'd10000;
	reg [7:0] speed_counter;  // 10 second 

	always @(posedge clk) begin
	
		// Reset condition
		if(rst) begin
			speed =20'd0;
			speed_counter = 8'd0;
		end
		else begin
			if(start_game)begin
				speed_counter = speed_counter + 4'd1;
				if(speed_counter == 8'd10) begin
					speed_counter = 8'd0;
					speed = speed - 20'd100;
				end
				if(speed == 20'd0) 
					speed = 20'd10000;
				end 
			end 
		end
	end
endmodule
