`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Stephanie Doan
//
// Create Date:   06:22:20 02/04/2021
// Design Name:   clock_gen
// Module Name:   /home/ise/xilinx/lab2/testbench_604981556.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_gen
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
	reg clk_in;
    reg rst;

	// Outputs
	wire clk_div_2;
    wire clk_div_4;
    wire clk_div_8;
    wire clk_div_16;
    wire clk_div_28;
    wire clk_div_5;
    wire [7:0] toggle_counter;

	// Instantiate the Unit Under Test (UUT)
	clock_gen uut (
		.clk_in(clk_in),
		.rst(rst),
		.clk_div_2(clk_div_2),
		.clk_div_4(clk_div_4),
		.clk_div_8(clk_div_8),
		.clk_div_16(clk_div_16),
		.clk_div_28(clk_div_28),
		.clk_div_5(clk_div_5),
		.toggle_counter(toggle_counter)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100
		rst = 1;
		
		// Add stimulus here
		#100
		rst = 0;

	end

	always @*
	begin
		#5
		clk_in <= ~clk_in;
	end
      
endmodule
