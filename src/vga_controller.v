`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Anmol Gupta, MS-CE
// 
// Create Date:    22:26:14 12/11/2015 
// Design Name: 
// Module Name:    vga_controller 
// Project Name: Lane Splitter
// Target Devices: The Nexys3 is a complete, ready to Xilinx Spartan6 LX16 FPGA
// Tool versions: 
// Description: As the name of the file suggests, the file contains the VGA driver
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_controller_640_60 (rst,pixel_clk,HS,VS,hcounter,vcounter,blank);

	input rst, pixel_clk;	// global reset, pixel clock
	output reg HS, VS, blank;	// sync controls, blank indicator
	output reg [10:0] hcounter, vcounter;	// pixel coordinates

	// Update these values based on the monitor and the FPGA used
	parameter HMAX = 800; 	// maxium value for the horizontal pixel counter
	parameter VMAX = 525; 	// maxium value for the vertical pixel counter
	parameter HLINES = 640;	// total number of visible columns  HP  parameter HLINES = 640;
	parameter HFP = 648; 	// value for the horizontal counter where front porch ends
	parameter HSP = 744; 	// value for the horizontal counter where the synch pulse ends
	parameter VLINES = 480;	// total number of visible lines
	parameter VFP = 482; 	// value for the vertical counter where the frone proch ends
	parameter VSP = 484; 	// value for the vertical counter where the synch pulse ends
	parameter SPP = 0;		// value for the porch synchronization pulse

	wire video_enable;	// valid region indicator
	
	// create a video enabled region
	assign video_enable = (hcounter < HLINES && vcounter < VLINES) ? 1'b1 : 1'b0;
	
	// create a "blank" indicator
	always@(posedge pixel_clk)begin
		blank <= ~video_enable; 
	end
	
	// Create a horizontal beam trace (horizontal time):
	always@(posedge pixel_clk)begin
		if(rst == 1) hcounter <= 0;
		else if (hcounter == HMAX) hcounter <= 0;
		else hcounter <= hcounter + 1'b1;
	end
	
	// Create a vertical beam trace (vertical time):
	always@(posedge pixel_clk)begin
		if(rst == 1) vcounter <=0;
		else if(hcounter == HMAX) begin
			if(vcounter == VMAX) vcounter <= 0;
			else vcounter <= vcounter + 1'b1; 
		end
	end
	
	// Check if between horizontal porches,
	// if not send horizontal porch synchronization pulse
	always@(posedge pixel_clk)begin
		if(hcounter >= HFP && hcounter < HSP)
		HS <= SPP;
		else HS <= ~SPP; 
	end
	
	// Check if between vertical porches,
	// if not send vertical porch synchronization pulse
	always@(posedge pixel_clk)begin
		if(vcounter >= VFP && vcounter < VSP) VS <= SPP;
		else VS <= ~SPP; 
	end
	
	

endmodule