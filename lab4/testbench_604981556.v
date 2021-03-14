`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:11:50 03/12/2021
// Design Name:   parking_meter
// Module Name:   /home/ise/xilinx/lab4/testbench_604981556.v
// Project Name:  lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_604981556;

	// Inputs
	reg add1;
	reg add2;
    reg add3;
    reg add4;
	reg rst1;
	reg rst2;
	reg clk;
	reg rst;

	// Outputs
	wire [6:0] led_seg;
	wire a1;
	wire a2;
	wire a3;
	wire a4;
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;

	// Etc
	reg [14:0] i;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		// input
		.add1(add1),
		.add2(add2),
		.add3(add3),
		.add4(add4),
		.rst1(rst1),
		.rst2(rst2),
		.clk(clk),
		.rst(rst),
		// output
		.led_seg(led_seg),
		.a1(a1),
		.a2(a2),
		.a3(a3),
		.a4(a4),
		.val1(val1),
		.val2(val2),
		.val3(val3),
		.val4(val4)
	);

	initial begin
		// Initialize Inputs
		add1 = 0;
		add2 = 0;
		add3 = 0;
		add4 = 0;
		rst1 = 0;
		rst2 = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		zero_flash();
		#10000000;
		countdown_from_60();
		#10000000;
		countdown_from_300();
		#10000000;
		reset();
		#10000000;
		spec();
		#10000000;
	end

////// TEST CASES /////

task spec; begin
	pos_edge();		rst = 1;		neg_edge();
	pos_edge();		rst = 0;		neg_edge();
	full_cyc();
	pos_edge();		add4 = 1;		neg_edge();
	pos_edge();		add4 = 0;		neg_edge();
	i = 12000;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
	full_cyc();
	pos_edge();		add2 = 1;		neg_edge();
	pos_edge();		add2 = 0;		neg_edge();
	i = 1000;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
end endtask

task reset; begin
	pos_edge();		rst = 1;		neg_edge();
	pos_edge();		rst = 0;		neg_edge();
	full_cyc();
	pos_edge();		rst2 = 1;		neg_edge();
	pos_edge();		rst2 = 0;		neg_edge();
	i = 1000;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
	pos_edge();		rst1 = 1;		neg_edge();
	pos_edge();		rst1 = 0;		neg_edge();
	i = 1000;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
end endtask

task countdown_from_300; begin
	pos_edge();		rst = 1;		neg_edge();
	pos_edge();		rst = 0;		neg_edge();
	full_cyc();
	pos_edge();		add4 = 1;		neg_edge();
	pos_edge();		add4 = 0;		neg_edge();
	i = 15100;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
end endtask

task zero_flash; begin
	pos_edge();		rst = 1;		neg_edge();
	pos_edge();		rst = 0;		neg_edge();
	i = 1000;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
end endtask

task countdown_from_60; begin
	pos_edge();		rst = 1;		neg_edge();
	pos_edge();		rst = 0;		neg_edge();
	full_cyc();
	pos_edge();		add1 = 1;		neg_edge();
	pos_edge();		add1 = 0;		neg_edge();
	i = 6100;
	while (i > 0) begin 
		full_cyc();
		i = i - 1;
	end
end endtask

///////// CLK /////////

task full_cyc; begin
	pos_edge();
	neg_edge();
end endtask

task pos_edge; begin
	clk <= 1;
	#5000000;	// 100 Hz = 10000000 ns cycle -> 5000000 ns half cycle
end endtask

task neg_edge; begin
	clk <= 0;
	#5000000;
end endtask
     
endmodule
