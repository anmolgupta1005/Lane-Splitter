`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Anmol Gupta, MS-CE
// 
// Create Date:    22:25:08 12/11/2015 
// Design Name: 
// Module Name:    vga_display 
// Project Name: Lane Splitter
// Target Devices: The Nexys3 is a complete, ready to Xilinx Spartan6 LX16 FPGA
// Tool versions: 
// Description: Game controller :- based on the user input drives the VGA-controller
//
// Dependencies: vga_controller.v
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module game_controller(rst, clk, R, G, B, HS, VS, steer_left, steer_right,start);
	input wire rst;	// global reset
	input wire clk;	// 100MHz clk
	input wire steer_left; 	//to steer the control_car left
	input wire steer_right;	//to steer the control_car right
	input wire start; //starts playing game
	
	// color outputs to show on display (current pixel)
	output reg [2:0] R, G;
	output reg [1:0] B;
	output HS;
	output VS;
	
	// wire and reg declaration
	wire [10:0] hcount, vcount;	// coordinates for the current pixel
	wire blank;	// signal to indicate the current coordinate is blank
	wire initiate_left, initiate_right;
	wire clk_25Mhz, clk_1hz;
	wire [19:0] speed; 
	wire  start_game;
	wire rst_d;
	reg road=0;	
	reg lane1=0;
	reg lane2=0;
	reg grass=0;
	reg [9:0] x0=10'd0,y0=10'd50;
	reg [9:0] x1=10'd0,y1=10'd70;
	reg [9:0] x2=10'd0,y2=10'd70;
	reg [9:0] x3=10'd0,y3=10'd70;
	reg [9:0] row1=10'd195,row2=10'd295,row3=10'd395,row_car=10'd295;
	reg temp_box1_start=1;
	reg temp_box1=0;
	reg [19:0] temp_box1_counter =20'd0;
	reg temp_box2_start=0;
	reg temp_box2=0;
	reg [19:0] temp_box2_counter =20'd0;
	reg temp_box3_start=0;
	reg temp_box3=0;
	reg [19:0] temp_box3_counter =20'd0;
	reg control_car=0;
	reg [19:0] steer_counter=0;
	reg  start_steer_right=0,start_steer_left=0;
	reg game_over=0,crashed_finish=0; 
	reg c1=0,c2=0,c3=0;
	reg r1=0,r2=0,r3=0,r4=0,r5=0, r5_display=0;
	reg a1=0,a2=0,a3=0,a4=0;
	reg s1=0,s2=0,s3=0,s4=0,s5=0;
	reg h1=0,h2=0,h3=0;
	reg e1=0,e2=0,e3=0,e4=0;
	reg d1=0,d2=0, d3=0, d4=0;
	reg [10:0] slope_x=0;
	reg [31:0]transition_counter=32'd0, blinking_counter=32'd0;
	reg print_c=0,print_r=0,print_a=0,print_s=0,print_h=0,print_e=0,print_d=0;
	reg d1_a=0,d1_b=0,d1_c=0,d1_d=0,d1_e=0,d1_f=0,d1_g=0;
	reg d2_a=0,d2_b=0,d2_c=0,d2_d=0,d2_e=0,d2_f=0,d2_g=0;
	reg d3_a=0,d3_b=0,d3_c=0,d3_d=0,d3_e=0,d3_f=0,d3_g=0;
	reg d4_a=0,d4_b=0,d4_c=0,d4_d=0,d4_e=0,d4_f=0,d4_g=0;
	reg go_d1_a=0,go_d1_b=0,go_d1_c=0,go_d1_d=0,go_d1_e=0,go_d1_f=0,go_d1_g=0;
	reg go_d2_a=0,go_d2_b=0,go_d2_c=0,go_d2_d=0,go_d2_e=0,go_d2_f=0,go_d2_g=0;
	reg go_d3_a=0,go_d3_b=0,go_d3_c=0,go_d3_d=0,go_d3_e=0,go_d3_f=0,go_d3_g=0;
	reg go_d4_a=0,go_d4_b=0,go_d4_c=0,go_d4_d=0,go_d4_e=0,go_d4_f=0,go_d4_g=0;
	reg [9:0] score_data=0;
	reg [9:0] temp=0;
    integer i;
	reg [3:0] digit [3:0];
	reg en_d1a=0,en_d1b=0,en_d1c=0,en_d1d=0,en_d1e=0,en_d1f=0,en_d1g=0;
	reg en_d2a=0,en_d2b=0,en_d2c=0,en_d2d=0,en_d2e=0,en_d2f=0,en_d2g=0;
	reg en_d3a=0,en_d3b=0,en_d3c=0,en_d3d=0,en_d3e=0,en_d3f=0,en_d3g=0;
	reg en_d4a=0,en_d4b=0,en_d4c=0,en_d4d=0,en_d4e=0,en_d4f=0,en_d4g=0;
	reg f1=0,f2=0,f3=0;
	reg i1=0,i2=0,i3=0;
	reg n1=0,n2=0,n2_display=0,n3=0;
	reg a1_1=0,a1_2=0,a1_3=0,a1_4=0;
	reg l1=0,l2=0;
	reg s1_1=0,s1_2=0,s1_3=0,s1_4=0,s1_5=0;
	reg c1_1=0,c1_2=0,c1_3=0;
	reg o1=0,o2=0,o3=0,o4=0;
	reg r1_1=0,r1_2=0,r1_3=0,r1_4=0,r1_5=0,r1_5_display=0;
	reg e1_1=0,e1_2=0,e1_3=0,e1_4=0;
	reg [14:0] n2_x=10'd0,r1_x=10'd0;
	reg b1_1=0,b1_2=0,b1_3=0,b1_4=0;
	reg b2_1=0,b2_2=0,b2_3=0,b2_4=0;
	reg print_score=0;
	reg start_screen=1;
	reg s_n9_1=0,s_n9_2=0,s_n9_3=0,s_n9_4=0,s_n9_5=0;
	reg s_c1=0,s_c2=0,s_c3=0;
	reg s_n1=0,s_n2=0,s_n3=0,s_n2_display = 0;
	reg [14:0] s_n2_x=0,s_r5_x=0, s_1_r5_x=0;
	reg s_i1=0,s_i2=0,s_i3=0;
	reg s_o1=0,s_o2=0,s_o3=0,s_o4=0;
	reg s_g1=0,s_g2=0,s_g3=0,s_g4=0,s_g5=0;
	reg s_e1=0,s_e2=0,s_e3=0,s_e4=0;
	reg s_b1=0,s_b2=0,s_b3=0,s_b4=0,s_b5=0;
	reg s_1_o1=0,s_1_o2=0,s_1_o3=0,s_1_o4=0;    				
	reg s_t1=0,s_t2=0;
	reg s_1_r1=0,s_1_r2=0,s_1_r3=0, s_1_r4=0, s_1_r5_display = 0,s_1_r5=0;;
	reg s_1_u1=0,s_1_u2=0,s_1_u3=0;
	reg s_h1=0,s_h2=0,s_h3=0;
	reg s_1_h1=0,s_1_h2=0,s_1_h3=0;
	reg s_s1=0,s_s2=0,s_s3=0,s_s4=0,s_s5=0;
	reg s_u1=0,s_u2=0,s_u3=0;
	reg s_r1=0,s_r2=0,s_r3=0,s_r5_display = 0, s_r4=0,s_r5=0;
	reg play_game=0;

  	// calling clock division
	clock_divison clock_generate(.clk(clk), .clk_25Mhz(clk_25Mhz), .clk_1hz(clk_1hz));
	
	// Call VGA driver
	vga_controller_640_60 vc(
		.rst(rst), 
		.pixel_clk(clk_25Mhz), 
		.HS(HS), 
		.VS(VS), 
		.hcounter(hcount), 
		.vcounter(vcount), 
		.blank(blank));
	
	//calling debouncer logic
	Debouncer steer_left_input(.clock(clk),.trigger(steer_left), .out(initiate_left));
	Debouncer steer_right_input(.clock(clk),.trigger(steer_right),.out(initiate_right));
	Debouncer reset_input(.clock(clk), .trigger(rst), .out(reset));
    Debouncer start_input(.clock(clk), .trigger(start), .out(start_game));
	
	// speed control 
	speed_control level(.clk(clk_1hz), .rst(reset), .start_game(start_game),.speed(speed));
	
	     
	// send colors:
	always @ (posedge clk) begin
	
		if(reset)begin
			start_screen=1; play_game=0;
			road=0;lane1=0;lane2=0;grass=0;
			x0=10'd0;y0=10'd50;x1=10'd0;y1=10'd70;
			x2=10'd0;y2=10'd70;x3=10'd0;y3=10'd70;
			row1=10'd195;row2=10'd295;row3=10'd395;row_car=10'd295;
			temp_box1_start=1;temp_box1=0;temp_box1_counter =20'd0;
			temp_box2_start=0;temp_box2=0;temp_box2_counter =20'd0;
			temp_box3_start=0;temp_box3=0;temp_box3_counter =20'd0;
			control_car=0;steer_counter=0;start_steer_right=0;
			start_steer_left=0;game_over=0;crashed_finish=0;c1=0;c2=0;c3=0;
			r1=0;r2=0;r3=0;r4=0;r5=0;r5_display=0;a1=0;a2=0;a3=0;a4=0;
			s1=0;s2=0;s3=0;s4=0;s5=0;h1=0;h2=0;h3=0;e1=0;e2=0;e3=0;e4=0;
			d1=0;d2=0;d3=0;d4=0;slope_x=0;transition_counter=32'd0; blinking_counter=32'd0;
			print_c=0;print_r=0;print_a=0;print_s=0;print_h=0;print_e=0;print_d=0;
			d1_a=0;d1_b=0;d1_c=0;d1_d=0;d1_e=0;d1_f=0;d1_g=0;
			d2_a=0;d2_b=0;d2_c=0;d2_d=0;d2_e=0;d2_f=0;d2_g=0;
			d3_a=0;d3_b=0;d3_c=0;d3_d=0;d3_e=0;d3_f=0;d3_g=0;
			d4_a=0;d4_b=0;d4_c=0;d4_d=0;d4_e=0;d4_f=0;d4_g=0;
			go_d1_a=0;go_d1_b=0;go_d1_c=0;go_d1_d=0;go_d1_e=0;go_d1_f=0;go_d1_g=0;
			go_d2_a=0;go_d2_b=0;go_d2_c=0;go_d2_d=0;go_d2_e=0;go_d2_f=0;go_d2_g=0;
			go_d3_a=0;go_d3_b=0;go_d3_c=0;go_d3_d=0;go_d3_e=0;go_d3_f=0;go_d3_g=0;
			go_d4_a=0;go_d4_b=0;go_d4_c=0;go_d4_d=0;go_d4_e=0;go_d4_f=0;go_d4_g=0;
			f1=0;f2=0;f3=0;i1=0;i2=0;i3=0;n1=0;n2=0;n2_display=0;n3=0;
			a1_1=0;a1_2=0;a1_3=0;a1_4=0;l1=0;l2=0;s1_1=0;s1_2=0;s1_3=0;s1_4=0;s1_5=0;
			c1_1=0;c1_2=0;c1_3=0;o1=0;o2=0;o3=0;o4=0;r1_1=0;r1_2=0;r1_3=0;r1_4=0;r1_5=0;r1_5_display=0;
			e1_1=0;e1_2=0;e1_3=0;e1_4=0;n2_x=10'd0;r1_x=10'd0; b1_1=0;b1_2=0;b1_3=0;b1_4=0;
			b2_1=0;b2_2=0;b2_3=0;b2_4=0; print_score=0;	  
			s_n9_1=0;s_n9_2=0;s_n9_3=0;s_n9_4=0;s_n9_5=0;
			s_c1=0;s_c2=0;s_c3=0;
			s_n1=0;s_n2=0;s_n3=0;s_n2_display = 0;s_n2_x=0;
			s_i1=0;s_i2=0;s_i3=0;
			s_g1=0;s_g2=0;s_g3=0;s_g4=0;s_g5=0;
			s_e1=0;s_e2=0;s_e3=0;s_e4=0;
			s_b1=0;s_b2=0;s_b3=0;s_b4=0;s_b5=0;
			s_1_o1=0;s_1_o2=0;s_1_o3=0;s_1_o4=0;
			s_t1=0;s_t2=0; s_1_r3=0;s_1_r4=0;
			s_1_r1=0;s_1_r2=0;s_1_r3=0;s_1_r5_display = 0; s_1_r5_x=0;
			s_1_u1=0;s_1_u2=0;s_1_u3=0;
			s_h1=0;s_h2=0;s_h3=0;
			s_1_h1=0;s_1_h2=0;s_1_h3=0;
			s_s1=0;s_s2=0;s_s3=0;s_s4=0;s_s5=0;
			s_u1=0;s_u2=0;s_u3=0;
			s_r1=0;s_r2=0;s_r3=0;s_r5_display = 0; s_r4=0; s_r5=0; s_r5_x=0;	 
		end
	
	else begin
	
	//display of start screen
	if(start_screen) begin	
		s_r1 = ~blank & ( hcount ==240 && vcount >=20 && vcount <= 120);
		s_r2= ~blank & ( hcount >=240 && hcount <=250 && vcount == 20);
		s_r3 = ~blank & ( hcount ==250 && vcount >=20 && vcount <= 70);
		s_r4 = ~blank & ( hcount >=240 && hcount <=250 && vcount ==70);
		if(hcount >=240 && hcount <=250 && vcount >=20 && vcount <=120)begin
			s_r5_x = hcount * 5; 
			s_r5_x = s_r5_x - 15'd1130;
		
	   	if((s_r5_x >= vcount-2) && (s_r5_x <= vcount + 2) )
			s_r5_display  = 1;
	   	else
			s_r5_display  = 0;
		end
		else 
		s_r5_display = 0;
		s_r5 = ~blank & s_r5_display;
		
		s_u1 =  ~blank & ( hcount ==260 && vcount >=20 && vcount <= 120);
		s_u2 =  ~blank & ( hcount >=260 && hcount <=270 && vcount == 120);
		s_u3 =  ~blank & ( hcount ==270 && vcount >=20 && vcount <= 120);
		
		s_s1 = ~blank & ( hcount >=280 && hcount <=290 && vcount == 20);
		s_s2 = ~blank & ( hcount ==280 && vcount >=20 && vcount <= 70); 
		s_s3 = ~blank & ( hcount >=280 && hcount <=290 && vcount == 70);
		s_s4 = ~blank & ( hcount ==290 && vcount >=70 && vcount <= 120); 
		s_s5 = ~blank & ( hcount >=280 && hcount <=290 && vcount == 120); 
		
		s_h1 = ~blank & ( hcount ==300 && vcount >=20 && vcount <= 120); 
		s_h2 = ~blank & ( hcount >=300 && hcount <=310 && vcount == 70); 
		s_h3 = ~blank & ( hcount ==310 && vcount >=20 && vcount <= 120);
		
		s_1_h1 = ~blank & ( hcount ==330 && vcount >=20 && vcount <= 120); 
		s_1_h2 = ~blank & ( hcount >=330 && hcount <=340 && vcount == 70); 
		s_1_h3 = ~blank & ( hcount ==340 && vcount >=20 && vcount <= 120);
		
		s_o1 = ~blank & (hcount >=350 && hcount <=360 && vcount == 20);
	   s_o2 = ~blank & ( hcount ==350 && vcount >=20 && vcount <= 120);
		s_o3 = ~blank & (hcount >=350 && hcount <=360 && vcount == 120);
		s_o4 = ~blank & ( hcount ==360 && vcount >=20 && vcount <= 120);
		
		s_1_u1 =  ~blank & ( hcount ==370 && vcount >=20 && vcount <= 120);
		s_1_u2 =  ~blank & ( hcount >=370 && hcount <=380 && vcount == 120);
		s_1_u3 = 	~blank & ( hcount ==380 && vcount >=20 && vcount <= 120); 
		
		s_1_r1 = ~blank & ( hcount ==390 && vcount >=20 && vcount <= 120);
		s_1_r2 = ~blank & ( hcount >=390 && hcount <=400 && vcount == 20);
		s_1_r3 = ~blank & ( hcount ==400 && vcount >=20 && vcount <= 70);
		s_1_r4 = ~blank & ( hcount >=390 && hcount <=400 && vcount == 70);
		if(hcount >=390 && hcount <=400 && vcount >=20 && vcount <=120)begin
		s_1_r5_x = hcount * 5; 
		s_1_r5_x = s_1_r5_x - 15'd1880;
		
	   if((s_1_r5_x >= vcount-2) && (s_1_r5_x <= vcount + 2 ))
		s_1_r5_display  = 1;
	   else
		s_1_r5_display  = 0;
		end
		else 
		s_1_r5_display= 0;
		s_1_r5 = ~blank & s_1_r5_display;
		
		
	   s_t1 =  ~blank & ( hcount ==435 && vcount >=300 && vcount <= 350);
		s_t2 =  ~blank & ( hcount >=430 && hcount <=440 && vcount == 300);
		
		s_1_o1 = ~blank & (hcount >=450 && hcount <=460 && vcount == 300);
	   s_1_o2 = ~blank & ( hcount ==450 && vcount >=300 && vcount <= 350);
		s_1_o3 = ~blank & (hcount >=450 && hcount <=460 && vcount == 350);
		s_1_o4 = ~blank & ( hcount ==460 && vcount >=300 && vcount <= 350);
		
		s_b1= ~blank & ( hcount ==480 && vcount >=300 && vcount <= 350);
		s_b2= ~blank & ( hcount ==490 && vcount >=300 && vcount <= 350);
	   s_b3= ~blank & ( hcount >=480 && hcount <=490 && vcount == 300);
		s_b4= ~blank & ( hcount >=480 && hcount <=490 && vcount == 325);
		s_b5= ~blank & ( hcount >=480 && hcount <=490 && vcount == 350);
		
		s_e1= ~blank & ( hcount ==500 && vcount >=300 && vcount <= 350);
		s_e2= ~blank & ( hcount >=500 && hcount <=510 && vcount == 300);
		s_e3= ~blank & ( hcount >=500 && hcount <=510 && vcount == 325);
		s_e4= ~blank & ( hcount >=500 && hcount <=510 && vcount == 350);
	  
		s_g1 =  ~blank & ( hcount >=520 && hcount <=530 && vcount == 300);
		s_g2=   ~blank & ( hcount == 520&& vcount >=300 && vcount <= 340);
		s_g3=  ~blank & ( hcount >=520 && hcount <=530 && vcount == 340);
		s_g4=   ~blank & ( hcount ==530 && vcount >=330 && vcount <= 350);
		s_g5=   ~blank & ( hcount >=520 && hcount <=530 && vcount == 330);
		
		s_i1 = ~blank & (hcount >=540 && hcount <=550 && vcount ==300);     
		s_i2 = ~blank & (hcount >=540 && hcount <=550 && vcount ==350);
		s_i3 = ~blank & (hcount ==545 && vcount >=300 && vcount <=350);
		
		s_n1 = ~blank & (hcount ==560 && vcount >=300 && vcount <=350);
		if(hcount >=560 && hcount <=570 && vcount >=300 && vcount <=350)begin
		s_n2_x = hcount * 5; 
		s_n2_x = s_n2_x - 15'd2500;
	   if((s_n2_x >= vcount-2) && (s_n2_x <= vcount + 2) )
		s_n2_display  = 1;
	   else
		s_n2_display  = 0;
		end
		else 
		s_n2_display = 0;
		s_n2 = ~blank & s_n2_display;
		s_n3 = ~blank & (hcount ==570 && vcount >=300 && vcount <=350);
		
		
		s_c1 = ~blank & ( hcount >=590 && hcount <=600 && vcount == 300);
		s_c2 = ~blank & ( hcount ==590 && vcount >=300 && vcount <= 350);
		s_c3 = ~blank & ( hcount >=590 && hcount <=600 && vcount == 350);
		
		s_n9_1 =  ~blank & ( hcount == 610&& vcount >=300 && vcount <= 325);
	 	s_n9_2 =  ~blank & ( hcount ==620 && vcount >=300 && vcount <= 350);
		s_n9_3 = ~blank & ( hcount >=610 && hcount <=620 && vcount == 300);
		s_n9_4 = ~blank & ( hcount >=610 && hcount <=620 && vcount == 325);
		s_n9_5 = ~blank & ( hcount >=610 && hcount <=620 && vcount == 350);
		
	end
		if(start_game)begin
		start_screen=0;
		play_game=1;
		temp_box1_start=1;
		end
		
		if(play_game)begin
		// defining static figures 
		// lane divider lines
		if(vcount > y0 )begin
		x0= x0+10'd80;
		y0= y0+10'd80;
		if(vcount>10'd450) begin
		x0=0;
		y0=10'd50;
		end
		end
		
	   lane1 = ~blank & (hcount >= 265 & hcount <= 275 & vcount >= x0 & vcount <= y0);
		lane2 = ~blank & (hcount >= 365 & hcount <= 375 & vcount >= x0 & vcount <= y0);
		road =  ~blank && (hcount >= 170 && hcount <= 470);
		grass = ~blank && ((hcount >=0 && hcount <170) || (hcount >470 && hcount <=640));
		
		//defining dynamic blocks and randomizing traffic
		if(temp_box1_start) begin
		if(vcount == 458)
		temp_box1_counter = temp_box1_counter +20'd1;
		if(temp_box1_counter == speed) begin
		x1= x1+10'd5;
		y1= y1+10'd5;
		if(y1 == 10'd525)begin
		x1= 10'd0;
		y1= 10'd70;
		row1=row1+10'd100;
		if(row1==10'd495)
		row1=10'd195;
		temp_box1_start=0;
		end
		if(y1 == 10'd240)
		temp_box2_start=1;
		temp_box1_counter = 20'd0;
		end
		end
		
		if(temp_box2_start) begin
		if(vcount == 458)
		temp_box2_counter = temp_box2_counter +20'd1;
		if(temp_box2_counter == speed) begin
		x2= x2+10'd5;
		y2= y2+10'd5;
		if(y2 == 10'd525) begin
		x2= 10'd0;
		y2= 10'd70;
		row2=row2+10'd100;
		if(row2==10'd495)
		row2=10'd195;
		temp_box2_start=0;
		end
		if(y2 == 10'd240)
		temp_box3_start=1;
		temp_box2_counter = 20'd0;
		end
		end

		
		if(temp_box3_start) begin
		if(vcount == 458)
		temp_box3_counter = temp_box3_counter +20'd1;
		if(temp_box3_counter == speed) begin
		x3= x3+10'd5;
		y3= y3+10'd5;
		if(y3 == 10'd525) begin
		x3= 10'd0;
		y3= 10'd70;
		row3=row3+10'd100;
		if(row3==10'd495)
		row3=10'd195;
		temp_box3_start=0;
		end
		if(y3 == 10'd240)
		temp_box1_start=1;
		temp_box3_counter = 20'd0;
		end
		end
		
		 
		temp_box1 = ~blank & (hcount >= row1 & hcount <= (row1+10'd50) & vcount >= x1 & vcount <= y1) & temp_box1_start;
		temp_box2 = ~blank & (hcount >= row2 & hcount <= (row2+10'd50) & vcount >= x2 & vcount <= y2) & temp_box2_start;
		temp_box3 = ~blank & (hcount >= row3 & hcount <= (row3+10'd50) & vcount >= x3 & vcount <= y3) & temp_box3_start;
		
		//control vehicle
		
		if(initiate_right)begin
		start_steer_right = 1;
		row_car = row_car + 10'd5;
		end
		if(initiate_left) begin
		start_steer_left = 1;
		row_car = row_car - 10'd5;
		end
		//steer right logic
		if(start_steer_right)begin
		steer_counter = steer_counter + 20'd1; 
		if(steer_counter == 20'd10000)begin
		row_car = row_car + 10'd5;
		steer_counter = 20'd0;
		end
		if((row_car == 10'd395)|| (row_car == 10'd295)) begin
		start_steer_right =0;
		steer_counter=0;
		end
		end
		//steer left logic
		if(start_steer_left)begin
		steer_counter = steer_counter + 20'd1;
		if(steer_counter == 20'd10000)begin
		row_car = row_car - 10'd5;
		steer_counter = 20'd0;
		end
		if((row_car == 10'd195) || (row_car == 10'd295)) begin
		start_steer_left =0;
		steer_counter=0;
		end
		end
		control_car = ~blank & (hcount >= row_car & hcount <= (row_car+10'd50) & vcount >= 420 & vcount <= 470);
		
		//crash control
		
		if((control_car && temp_box1) || (control_car && temp_box2) || (control_car && temp_box3) )
		game_over =1;

	if(game_over) begin 
		transition_counter = transition_counter + 20'd1;
	
	if(transition_counter >= 32'd100000000)
		print_c = 1; 
	
	if(print_c) begin
		c1 = ~blank & ( hcount >=20 && hcount <=40 && vcount == 200);
		c2 = ~blank & ( hcount ==20 && vcount >=200 && vcount <= 300);
		c3 = ~blank & ( hcount >=20 && hcount <=40 && vcount == 300);
	end
	
	if(transition_counter >= 32'd200000000)
		print_r = 1; 
	
	if(print_r)begin
		r1 = ~blank & ( hcount ==60 && vcount >=200 && vcount <= 300);
		r2 = ~blank & ( hcount >=60 && hcount <=80 && vcount == 200);
		r3 = ~blank & ( hcount ==80 && vcount >=200 && vcount <= 250);
		r4 = ~blank & ( hcount >=60 && hcount <=80 && vcount == 250);
	if(hcount >=60 && hcount <=80 && vcount >=250 && vcount <=300)begin
		slope_x = hcount * 5; 
		slope_x = slope_x >> 1;
		slope_x = slope_x + 10'd100;
	
   if((slope_x >= vcount-1) && (slope_x <= vcount + 1) )
		r5_display  = 1;
   else
		r5_display  = 0;
	end
	else 
		r5_display = 0;
		r5 = ~blank & r5_display;

	end
	
	if(transition_counter >= 32'd300000000)
		print_a = 1; 
	
	if(print_a)begin
		a1 = ~blank & ( hcount ==100 && vcount >=200 && vcount <= 300);
		a2 = ~blank & ( hcount >=100 && hcount <=120 && vcount == 200); 
		a3 = ~blank & ( hcount ==120 && vcount >=200 && vcount <= 300);
		a4 = ~blank & ( hcount >=100 && hcount <=120 && vcount == 250); 
	end
	
	if(transition_counter >= 32'd400000000)
		print_s = 1; 
	
	if(print_s)begin
		s1 = ~blank & ( hcount >=140 && hcount <=160 && vcount == 200);
		s2 = ~blank & ( hcount ==140 && vcount >=200 && vcount <= 250); 
		s3 = ~blank & ( hcount >=140 && hcount <=160 && vcount == 250);
		s4 = ~blank & ( hcount ==160 && vcount >=250 && vcount <= 300); 
		s5 = ~blank & ( hcount >=140 && hcount <=160 && vcount == 300); 
	end
	
	if(transition_counter >= 32'd500000000)
		print_h = 1; 
	
	if(print_h)begin
		h1 = ~blank & ( hcount ==180 && vcount >=200 && vcount <= 300); 
		h2 = ~blank & ( hcount >=180 && hcount <=200 && vcount == 250); 
		h3 = ~blank & ( hcount ==200 && vcount >=200 && vcount <= 300);
	end
	
	if(transition_counter >= 32'd600000000)
		print_e = 1; 
	
	if(print_e)begin
		e1 = ~blank & ( hcount ==220 && vcount >=200 && vcount <= 300); 
	    e2 = ~blank & ( hcount >=220 && hcount <=240 && vcount == 200); 
		e3 = ~blank & ( hcount >=220 && hcount <=240 && vcount == 250); 
		e4 = ~blank & ( hcount >=220 && hcount <=240 && vcount == 300); 
	end
	
	if(transition_counter >= 32'd7_00_000_000)
		print_d = 1; 
	
	if(print_d)begin
		d1 = ~blank & ( hcount ==260 && vcount >=200 && vcount <= 300); 
		d2 = ~blank & ( hcount >=257 && hcount <=290 && vcount == 200); 
		d3 = ~blank & ( hcount ==290 && vcount >=200 && vcount <= 300); 
		d4 = ~blank & ( hcount >=257 && hcount <=290 && vcount == 300); 
	end
	
	if(transition_counter >=32'd8_00_000_000 && crashed_finish ==0)begin
		print_score = 1;
		transition_counter = 32'd0;
		crashed_finish=1;
	end
	if(crashed_finish == 1) begin
		blinking_counter = blinking_counter + 32'd1;
	if( blinking_counter ==32'd1_00_000_000)begin
		print_score = ~print_score;
		blinking_counter = 32'd0;
	end
	end 
	
	if(print_score)begin
	
		f1 = ~blank & (hcount >=20 && hcount <=30 && vcount ==50);
		f2 = ~blank & (hcount >=20 && hcount <=25 && vcount ==75);
		f3 = ~blank & (hcount ==20 && vcount >=50 && vcount <=100);
		
		i1 = ~blank & (hcount >=40 && hcount <=50 && vcount ==50);     
		i2 = ~blank & (hcount >=40 && hcount <=50 && vcount ==100);
		i3 = ~blank & (hcount ==45 && vcount >=50 && vcount <=100);
		
		n1 = ~blank & (hcount ==60 && vcount >=50 && vcount <=100);
	if(hcount >=60 && hcount <=70 && vcount >=50 && vcount <=100)begin
		n2_x = hcount * 5; 
		n2_x = n2_x - 10'd250;
   if((n2_x >= vcount-2) && (n2_x <= vcount + 2) )
		n2_display  = 1;
   else
		n2_display  = 0;
	end
	else 
		n2_display = 0;
		n2 = ~blank & n2_display;
		n3 = ~blank & (hcount ==70 && vcount >=50 && vcount <=100);
		
		a1_1 = ~blank & ( hcount ==80 && vcount >=50 && vcount <= 100);
		a1_2 = ~blank & ( hcount >=80 && hcount <=90 && vcount == 50); 
		a1_3 = ~blank & ( hcount ==90 && vcount >=50 && vcount <= 100);
		a1_4 = ~blank & ( hcount >=80 && hcount <=90 && vcount == 75); 
		
		l1 = ~blank & ( hcount ==100 && vcount >=50 && vcount <= 100);
		l2 = ~blank & ( hcount >=100 && hcount <=110 && vcount == 100); 
		
		s1_1 = ~blank & ( hcount >=130 && hcount <=140 && vcount == 50);
		s1_2 = ~blank & ( hcount ==130 && vcount >=50&& vcount <= 75); 
		s1_3 = ~blank & ( hcount >=130 && hcount <=140 && vcount == 75);
		s1_4 = ~blank & ( hcount ==140 && vcount >=75 && vcount <= 100); 
		s1_5 = ~blank & ( hcount >=130 && hcount <=140 && vcount == 100); 
		
		c1_1 = ~blank & ( hcount >=150 && hcount <=160 && vcount == 50);
		c1_2 = ~blank & ( hcount ==150 && vcount >=50 && vcount <= 100);
		c1_3 = ~blank & ( hcount >=150 && hcount <=160 && vcount == 100);
		
		o1 = ~blank & (hcount >=170 && hcount <=180 && vcount == 50);
	   o2 = ~blank & ( hcount ==170 && vcount >=50 && vcount <= 100);
		o3 = ~blank & (hcount >=170 && hcount <=180 && vcount == 100);
		o4 = ~blank & ( hcount ==180 && vcount >=50 && vcount <= 100);
		
		r1_1 = ~blank & ( hcount ==190 && vcount >=50 && vcount <= 100);
		r1_2 = ~blank & ( hcount >=190 && hcount <=200 && vcount == 50);
		r1_3 = ~blank & ( hcount ==200 && vcount >=50 && vcount <= 75);
		r1_4 = ~blank & ( hcount >=190 && hcount <=200 && vcount == 75);
		if(hcount >=190 && hcount <=200 && vcount >=75 && vcount <=100)begin
			r1_x = hcount * 5; 
			r1_x = r1_x >> 1;
			r1_x = r1_x - 10'd400;
		
	   if((r1_x >= vcount-1) && (r1_x <= vcount + 1) )
			r1_5_display  = 1;
	   else
			r1_5_display  = 0;
		end
		else 
			r1_5_display = 0;
			r1_5 = ~blank & r1_5_display;
			
			e1_1 = ~blank & ( hcount ==210 && vcount >=50 && vcount <= 100); 
		    e1_2 = ~blank & ( hcount >=210 && hcount <=220 && vcount == 50); 
			e1_3 = ~blank & ( hcount >=210 && hcount <=220 && vcount == 75); 
			e1_4 = ~blank & ( hcount >=210 && hcount <=220 && vcount == 100); 
			
			b1_1 = ~blank & ( hcount ==225 && vcount >=60 && vcount <= 70); 
			b1_2 = ~blank & ( hcount >=225 && hcount <=230 && vcount == 60); 
			b1_3 = ~blank & ( hcount ==230 && vcount >=60 && vcount <= 70); 
			b1_4 = ~blank & ( hcount >=225 && hcount <=230 && vcount == 70);
			b2_1 = ~blank & ( hcount ==225 && vcount >=80 && vcount <= 90); 
			b2_2 = ~blank & ( hcount >=225 && hcount <=230 && vcount == 80);
			b2_3 = ~blank & ( hcount ==230 && vcount >=80 && vcount <= 90); 
			b2_4 = ~blank & ( hcount >=225 && hcount <=230 && vcount == 90);
			
		   go_d4_a = ~blank & (hcount >=240 && hcount <= 250 && vcount == 50)  && en_d4a;
			go_d4_b = ~blank & (hcount ==250 && vcount >=50 && vcount <= 75)    && en_d4b;
			go_d4_c = ~blank & (hcount ==250 && vcount >=75 && vcount <= 100)   && en_d4c;
			go_d4_d = ~blank & (hcount >=240 && hcount <= 250 && vcount == 100) && en_d4d;
			go_d4_e = ~blank & (hcount ==240 && vcount >=75 && vcount <= 100)   && en_d4e;
			go_d4_f = ~blank & (hcount ==240 && vcount >=50 && vcount <= 75)    && en_d4f;
			go_d4_g = ~blank & (hcount >=240 && hcount <= 250 && vcount == 75)  && en_d4g;
			
			go_d3_a = ~blank & (hcount >=260 && hcount <= 270 && vcount == 50)  && en_d3a;
			go_d3_b = ~blank & (hcount ==270 && vcount >=50 && vcount <= 75)    && en_d3b;
			go_d3_c = ~blank & (hcount ==270 && vcount >=75 && vcount <= 100)   && en_d3c;
			go_d3_d = ~blank & (hcount >=260 && hcount <= 270 && vcount == 100) && en_d3d;
			go_d3_e = ~blank & (hcount ==260 && vcount >=75 && vcount <= 100)   && en_d3e;
			go_d3_f = ~blank & (hcount ==260 && vcount >=50 && vcount <= 75)    && en_d3f;
			go_d3_g = ~blank & (hcount >=260 && hcount <= 270 && vcount == 75)  && en_d3g;
		
	      go_d2_a = ~blank & (hcount >=280 && hcount <= 290 && vcount == 50)  && en_d2a;
			go_d2_b = ~blank & (hcount ==290 && vcount >=50 && vcount <= 75)    && en_d2b;
			go_d2_c = ~blank & (hcount ==290 && vcount >=75 && vcount <= 100)   && en_d2c;
			go_d2_d = ~blank & (hcount >=280 && hcount <= 290 && vcount == 100) && en_d2d;
			go_d2_e = ~blank & (hcount ==280 && vcount >=75 && vcount <= 100)   && en_d2e;
			go_d2_f = ~blank & (hcount ==280 && vcount >=50 && vcount <= 75)    && en_d2f;
			go_d2_g = ~blank & (hcount >=280 && hcount <= 290 && vcount == 75)  && en_d2g;
			
			go_d1_a = ~blank & (hcount >=300 && hcount <= 310 && vcount == 50)  && en_d1a;
			go_d1_b = ~blank & (hcount ==310 && vcount >=50 && vcount <= 75)    && en_d1b;
			go_d1_c = ~blank & (hcount ==310 && vcount >=75 && vcount <= 100)   && en_d1c;
			go_d1_d = ~blank & (hcount >=300 && hcount <= 310 && vcount == 100) && en_d1d;
			go_d1_e = ~blank & (hcount ==300 && vcount >=75 && vcount <= 100)   && en_d1e;
			go_d1_f = ~blank & (hcount ==300 && vcount >=50 && vcount <= 75)    && en_d1f;
		   go_d1_g = ~blank & (hcount >=300 && hcount <= 310 && vcount == 75)  && en_d1g;
	end
	
	end
	
	
	//score display
	
		d4_a = ~blank & (hcount >=10 && hcount <= 20 && vcount == 10) && en_d4a;
		d4_b = ~blank & (hcount ==20 && vcount >=10 && vcount <= 20)  && en_d4b;
		d4_c = ~blank & (hcount ==20 && vcount >=20 && vcount <= 30)  && en_d4c;
		d4_d = ~blank & (hcount >=10 && hcount <= 20 && vcount == 30) && en_d4d;
		d4_e = ~blank & (hcount ==10 && vcount >=20 && vcount <= 30)  && en_d4e;
		d4_f = ~blank & (hcount ==10 && vcount >=10 && vcount <= 20)  && en_d4f;
		d4_g = ~blank & (hcount >=10 && hcount <= 20 && vcount == 20) && en_d4g;

		d3_a = ~blank & (hcount >=30 && hcount <= 40 && vcount == 10) && en_d3a;
		d3_b = ~blank & (hcount ==40 && vcount >=10 && vcount <= 20)  && en_d3b;
		d3_c = ~blank & (hcount ==40 && vcount >=20 && vcount <= 30)  && en_d3c;
		d3_d = ~blank & (hcount >=30 && hcount <= 40 && vcount == 30) && en_d3d;
		d3_e = ~blank & (hcount ==30 && vcount >=20 && vcount <= 30)  && en_d3e;
		d3_f = ~blank & (hcount ==30 && vcount >=10 && vcount <= 20)  && en_d3f;
		d3_g = ~blank & (hcount >=30 && hcount <= 40 && vcount == 20) && en_d3g;

		d2_a = ~blank & (hcount >=50 && hcount <= 60 && vcount == 10) && en_d2a;
		d2_b = ~blank & (hcount ==60 && vcount >=10 && vcount <= 20)  && en_d2b;
		d2_c = ~blank & (hcount ==60 && vcount >=20 && vcount <= 30)  && en_d2c;
		d2_d = ~blank & (hcount >=50 && hcount <= 60 && vcount == 30) && en_d2d;
		d2_e = ~blank & (hcount ==50 && vcount >=20 && vcount <= 30)  && en_d2e;
		d2_f = ~blank & (hcount ==50 && vcount >=10 && vcount <= 20)  && en_d2f;
		d2_g = ~blank & (hcount >=50 && hcount <= 60 && vcount == 20) && en_d2g;

		d1_a = ~blank & (hcount >=70 && hcount <= 80 && vcount == 10) && en_d1a;
		d1_b = ~blank & (hcount ==80 && vcount >=10 && vcount <= 20)  && en_d1b;
		d1_c = ~blank & (hcount ==80 && vcount >=20 && vcount <= 30)  && en_d1c;
		d1_d = ~blank & (hcount >=70 && hcount <= 80 && vcount == 30) && en_d1d;
		d1_e = ~blank & (hcount ==70 && vcount >=20 && vcount <= 30)  && en_d1e;
		d1_f = ~blank & (hcount ==70 && vcount >=10 && vcount <= 20)  && en_d1f;
		d1_g = ~blank & (hcount >=70 && hcount <= 80 && vcount == 20) && en_d1g;
		
		end
		
		//assinging colours
		if(start_screen) begin
			road=0;
			f1=0;f2=0;f3=0;i1=0;i2=0;i3=0;n1=0;n2=0;n3=0;a1_1=0;a1_2=0;a1_3=0;a1_4=0;
			l1=0;l2=0;s1_1=0;s1_2=0;s1_3=0;s1_4=0;s1_5=0;c1_1=0;c1_2=0;c1_3=0;o1=0;o2=0;o3=0;o4=0;
			r1_1=0;r1_2=0;r1_3=0;r1_4=0;r1_5=0;e1_1=0;e1_2=0;e1_3=0;e1_4=0;b1_1=0;b1_2=0;b1_3=0;
			b1_4=0;b2_1=0;b2_2=0;b2_3=0;b2_4=0;go_d1_a =0; go_d1_b =0; go_d1_c =0; go_d1_d =0; go_d1_e =0; go_d1_f =0; go_d1_g =0;
			go_d2_a =0; go_d2_b =0; go_d2_c =0; go_d2_d =0; go_d2_e =0; go_d2_f =0; go_d2_g =0;
			go_d3_a =0; go_d3_b =0; go_d3_c =0; go_d3_d =0; go_d3_e =0; go_d3_f =0; go_d3_g =0;
			go_d4_a =0; go_d4_b =0; go_d4_c =0; go_d4_d =0; go_d4_e =0; go_d4_f =0; go_d4_g=0;
			lane1=0;
			lane2=0;
			temp_box1=0;
			temp_box2=0;
			temp_box3=0;
			control_car=0;
			road=0;
			grass=0;
			temp_box1_start=0;
			temp_box2_start=0;
			temp_box3_start=0;
			d4_a=0;d4_b=0;d4_c=0;d4_d=0;d4_e=0;d4_f=0;d4_g=0;
			d3_a=0;d3_b=0;d3_c=0;d3_d=0;d3_e=0;d3_f=0;d3_g=0;
			d2_a=0;d2_b=0;d2_c=0;d2_d=0;d2_e=0;d2_f=0;d2_g=0;
			d1_a=0;d1_b=0;d1_c=0;d1_d=0;d1_e=0;d1_f=0;d1_g=0;
		end
		else begin  
		if (lane1 || lane2 || temp_box1 || temp_box2 || temp_box3 || control_car)
			road=0;
		
		if(d1_a || d1_b || d1_c || d1_d || d1_e || d1_f || d1_g ||
					d2_a || d2_b || d2_c || d2_d || d2_e || d2_f || d2_g ||
					d3_a || d3_b || d3_c || d3_d || d3_e || d3_f || d3_g ||
					d4_a || d4_b || d4_c || d4_d || d4_e || d4_f || d4_g)
			grass=0;
		if(game_over) begin
			lane1=0;
			lane2=0;
			temp_box1=0;
			temp_box2=0;
			temp_box3=0;
			control_car=0;
			road=0;
			grass=0;
			temp_box1_start=0;
			temp_box2_start=0;
			temp_box3_start=0;
			d4_a=0;d4_b=0;d4_c=0;d4_d=0;d4_e=0;d4_f=0;d4_g=0;
			d3_a=0;d3_b=0;d3_c=0;d3_d=0;d3_e=0;d3_f=0;d3_g=0;
			d2_a=0;d2_b=0;d2_c=0;d2_d=0;d2_e=0;d2_f=0;d2_g=0;
			d1_a=0;d1_b=0;d1_c=0;d1_d=0;d1_e=0;d1_f=0;d1_g=0;
		end
		end
		
		if (road) begin	// if you are within the valid region
			R = 3'd0;
			G = 3'd0;
			B = 2'd0;
		end
		else if (lane1 || lane2) begin
			R= 3'd7;
			G= 3'd7;
			B= 2'd3;
		end
		else if(grass) begin
		  	R = 3'd0;
			G = 3'd2;
			B = 2'd0;
		end 
		else if(temp_box1 || temp_box2 || temp_box3) begin
		   	R = 3'd5;
			G = 3'd0;
			B = 2'd0; 
		end
		else if(control_car) begin
			R = 3'd5;
			G = 3'd5;
			B = 2'd0;
		end
		else if(c1 || c2 || c3 || r1 || r2 || r3 || r4 || r5 ||
		    a1 || a2 || a3 || a4 || s1 || s2 || s3 || s4 || s5 ||
			 h1 || h2 || h3 || e1 || e2 || e3 || e4 || d1 || d2 ||
			 d3 || d4) begin 
			R = 3'd5;
			G = 3'd0;
			B = 2'd0;
		end
		else if (d1_a || d1_b || d1_c || d1_d || d1_e || d1_f || d1_g ||
					d2_a || d2_b || d2_c || d2_d || d2_e || d2_f || d2_g ||
					d3_a || d3_b || d3_c || d3_d || d3_e || d3_f || d3_g ||
					d4_a || d4_b || d4_c || d4_d || d4_e || d4_f || d4_g) begin	
			R = 3'd0;
			G = 3'd0;
			B = 2'd3;
		end
		else if (f1||f2||f3||i1||i2||i3||n1||n2||n3||a1_1||a1_2||a1_3||a1_4||
			l1||l2||s1_1||s1_2||s1_3||s1_4||s1_5||c1_1||c1_2||c1_3||o1||o2||o3||o4||
			r1_1||r1_2||r1_3||r1_4||r1_5||e1_1||e1_2||e1_3||e1_4||b1_1||b1_2||b1_3||
			b1_4||b2_1||b2_2||b2_3||b2_4||go_d1_a || go_d1_b || go_d1_c || go_d1_d || go_d1_e || go_d1_f || go_d1_g ||
			go_d2_a || go_d2_b || go_d2_c || go_d2_d || go_d2_e || go_d2_f || go_d2_g ||
			go_d3_a || go_d3_b || go_d3_c || go_d3_d || go_d3_e || go_d3_f || go_d3_g ||
			go_d4_a || go_d4_b || go_d4_c || go_d4_d || go_d4_e || go_d4_f || go_d4_g) begin
			   R = 3'd0;
			G = 3'd5;
			B = 2'd0;
			end
			else if(     s_n9_1||s_n9_2||s_n9_3||s_n9_4||s_n9_5||s_c1||s_c2||s_c3||s_n1||s_n2||s_n3|| s_1_r4|| s_1_r5||
								s_i1||s_i2||s_i3||s_g1||s_g2||s_g3||s_g4||s_g5|| s_e1||s_e2||s_e3||s_e4|| s_b1||s_b2||s_b3||s_b4||s_b5||
								s_1_o1||s_1_o2||s_1_o3||s_1_o4|| s_t1||s_t2||s_1_r1||s_1_r2||s_1_r3||s_1_u1||s_1_u2||s_1_u3|| s_o1||s_o2||s_o3||s_o4||
								s_h1||s_h2||s_h3||s_1_h1||s_1_h2||s_1_h3||s_s1||s_s2||s_s3||s_s4||s_s5||s_u1||s_u2||s_u3|| s_r1||s_r2||s_r3||s_r4||s_r5) begin
			R = 3'd5;
			G = 3'd5;
			B = 2'd2;	
			end
		else begin	// if you are outside the valid region
			R = 3'd0;
			G = 3'd0;
			B = 2'd0;
		end 
		end
	end
	
	//score keeper
	
	always @(posedge clk_1hz, posedge  reset) begin 
	
	if(reset) begin
		 score_data=0; i=0;
	     temp=0;en_d1a=0;en_d1b=0;en_d1c=0;en_d1d=0;en_d1e=0;en_d1f=0;en_d1g=0;
		 en_d2a=0;en_d2b=0;en_d2c=0;en_d2d=0;en_d2e=0;en_d2f=0;en_d2g=0;
		 en_d3a=0;en_d3b=0;en_d3c=0;en_d3d=0;en_d3e=0;en_d3f=0;en_d3g=0;
		 en_d4a=0;en_d4b=0;en_d4c=0;en_d4d=0;en_d4e=0;en_d4f=0;en_d4g=0;
	 end
	 
	else begin
	if(play_game)begin
		if(game_over==0)begin
			score_data = score_data + 10'd1;
			temp=score_data;
		
		for (i=0; i<=3;i=i+1) begin
			digit[i] = temp%10;
			temp = temp/10;
	   end
		
		case(digit[0]) 
		4'd0: begin
				en_d1a=1;en_d1b=1; en_d1c=1;en_d1d=1;en_d1e=1;en_d1f=1;en_d1g=0;
				end
		4'd1: begin
				en_d1a=0;en_d1b=1; en_d1c=1;en_d1d=0;en_d1e=0;en_d1f=0;en_d1g=0;
				end
		4'd2: begin
				en_d1a=1;en_d1b=1; en_d1c=0;en_d1d=1;en_d1e=1;en_d1f=0;en_d1g=1;
				end
		4'd3: begin
				en_d1a=1;en_d1b=1; en_d1c=1;en_d1d=1;en_d1e=0;en_d1f=0;en_d1g=1;
				end
		4'd4: begin
				en_d1a=0;en_d1b=1; en_d1c=1;en_d1d=0;en_d1e=0;en_d1f=1;en_d1g=1;
				end
		4'd5: begin
				en_d1a=1;en_d1b=0; en_d1c=1;en_d1d=1;en_d1e=0;en_d1f=1;en_d1g=1;
				end
		4'd6: begin
				en_d1a=1;en_d1b=0; en_d1c=1;en_d1d=1;en_d1e=1;en_d1f=1;en_d1g=1;
				end
		4'd7: begin
				en_d1a=1;en_d1b=1; en_d1c=1;en_d1d=0;en_d1e=0;en_d1f=0;en_d1g=0;
				end	
		4'd8: begin
				en_d1a=1;en_d1b=1; en_d1c=1;en_d1d=1;en_d1e=1;en_d1f=1;en_d1g=1;
				end
		4'd9: begin
				en_d1a=1;en_d1b=1; en_d1c=1;en_d1d=1;en_d1e=0;en_d1f=1;en_d1g=1;
				end
		default: begin
					en_d1a=1;en_d1b=1; en_d1c=1;en_d1d=1;en_d1e=1;en_d1f=1;en_d1g=0;
					end
		endcase
	   	
			case(digit[1]) 
		4'd0: begin
				en_d2a=1;en_d2b=1; en_d2c=1;en_d2d=1;en_d2e=1;en_d2f=1;en_d2g=0;
				end
		4'd1: begin
				en_d2a=0;en_d2b=1; en_d2c=1;en_d2d=0;en_d2e=0;en_d2f=0;en_d2g=0;
				end
		4'd2: begin
				en_d2a=1;en_d2b=1; en_d2c=0;en_d2d=1;en_d2e=1;en_d2f=0;en_d2g=1;
				end
		4'd3: begin
				en_d2a=1;en_d2b=1; en_d2c=1;en_d2d=1;en_d2e=0;en_d2f=0;en_d2g=1;
				end
		4'd4: begin
				en_d2a=0;en_d2b=1; en_d2c=1;en_d2d=0;en_d2e=0;en_d2f=1;en_d2g=1;
				end
		4'd5: begin
				en_d2a=1;en_d2b=0; en_d2c=1;en_d2d=1;en_d2e=0;en_d2f=1;en_d2g=1;
				end
		4'd6: begin
				en_d2a=1;en_d2b=0; en_d2c=1;en_d2d=1;en_d2e=1;en_d2f=1;en_d2g=1;
				end
		4'd7: begin
				en_d2a=1;en_d2b=1; en_d2c=1;en_d2d=0;en_d2e=0;en_d2f=0;en_d2g=0;
				end	
		4'd8: begin
				en_d2a=1;en_d2b=1; en_d2c=1;en_d2d=1;en_d2e=1;en_d2f=1;en_d2g=1;
				end
		4'd9: begin
				en_d2a=1;en_d2b=1; en_d2c=1;en_d2d=1;en_d2e=0;en_d2f=1;en_d2g=1;
				end
		default: begin
					en_d2a=1;en_d2b=1; en_d2c=1;en_d2d=1;en_d2e=1;en_d2f=1;en_d2g=0;
					end
		endcase
		
		case(digit[2]) 
		4'd0: begin
				en_d3a=1;en_d3b=1; en_d3c=1;en_d3d=1;en_d3e=1;en_d3f=1;en_d3g=0;
				end
		4'd1: begin
				en_d3a=0;en_d3b=1; en_d3c=1;en_d3d=0;en_d3e=0;en_d3f=0;en_d3g=0;
				end
		4'd2: begin
				en_d3a=1;en_d3b=1; en_d3c=0;en_d3d=1;en_d3e=1;en_d3f=0;en_d3g=1;
				end
		4'd3: begin
				en_d3a=1;en_d3b=1; en_d3c=1;en_d3d=1;en_d3e=0;en_d3f=0;en_d3g=1;
				end
		4'd4: begin
				en_d3a=0;en_d3b=1; en_d3c=1;en_d3d=0;en_d3e=0;en_d3f=1;en_d3g=1;
				end
		4'd5: begin
				en_d3a=1;en_d3b=0; en_d3c=1;en_d3d=1;en_d3e=0;en_d3f=1;en_d3g=1;
				end
		4'd6: begin
				en_d3a=1;en_d3b=0; en_d3c=1;en_d3d=1;en_d3e=1;en_d3f=1;en_d3g=1;
				end
		4'd7: begin
				en_d3a=1;en_d3b=1; en_d3c=1;en_d3d=0;en_d3e=0;en_d3f=0;en_d3g=0;
				end	
		4'd8: begin
				en_d3a=1;en_d3b=1; en_d3c=1;en_d3d=1;en_d3e=1;en_d3f=1;en_d3g=1;
				end
		4'd9: begin
				en_d3a=1;en_d3b=1; en_d3c=1;en_d3d=1;en_d3e=0;en_d3f=1;en_d3g=1;
				end
		default: begin
					en_d3a=1;en_d3b=1; en_d3c=1;en_d3d=1;en_d3e=1;en_d3f=1;en_d3g=0;
					end
		endcase
		
		case(digit[3]) 
		4'd0: begin
				en_d4a=1;en_d4b=1; en_d4c=1;en_d4d=1;en_d4e=1;en_d4f=1;en_d4g=0;
				end
		4'd1: begin
				en_d4a=0;en_d4b=1; en_d4c=1;en_d4d=0;en_d4e=0;en_d4f=0;en_d4g=0;
				end
		4'd2: begin
				en_d4a=1;en_d4b=1; en_d4c=0;en_d4d=1;en_d4e=1;en_d4f=0;en_d4g=1;
				end
		4'd3: begin
				en_d4a=1;en_d4b=1; en_d4c=1;en_d4d=1;en_d4e=0;en_d4f=0;en_d4g=1;
				end
		4'd4: begin
				en_d4a=0;en_d4b=1; en_d4c=1;en_d4d=0;en_d4e=0;en_d4f=1;en_d4g=1;
				end
		4'd5: begin
				en_d4a=1;en_d4b=0; en_d4c=1;en_d4d=1;en_d4e=0;en_d4f=1;en_d4g=1;
				end
		4'd6: begin
				en_d4a=1;en_d4b=0; en_d4c=1;en_d4d=1;en_d4e=1;en_d4f=1;en_d4g=1;
				end
		4'd7: begin
				en_d4a=1;en_d4b=1; en_d4c=1;en_d4d=0;en_d4e=0;en_d4f=0;en_d4g=0;
				end	
		4'd8: begin
				en_d4a=1;en_d4b=1; en_d4c=1;en_d4d=1;en_d4e=1;en_d4f=1;en_d4g=1;
				end
		4'd9: begin
				en_d4a=1;en_d4b=1; en_d4c=1;en_d4d=1;en_d4e=0;en_d4f=1;en_d4g=1;
				end
		default: begin
					en_d4a=1;en_d4b=1; en_d4c=1;en_d4d=1;en_d4e=1;en_d4f=1;en_d4g=0;
					end
		endcase
  end
  end
end
end
endmodule
