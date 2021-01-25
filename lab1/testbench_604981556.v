`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Stephanie Doan
//
// Create Date:   07:54:57 01/23/2021
// Design Name:   FPCVT
// Module Name:   /home/ise/xilinx/lab1/testbench_604981556.v
// Project Name:  lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
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
	reg [12:0] D;

	// Outputs
	wire S;
    wire [2:0] E;
    wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D),
		.S(S),
		.E(E),
		.F(F)
	);

	initial begin
		// Initialize Inputs
		D = 13'b0000000000000;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here

		// ROUND DOWN (given in spec)

		// 108: 0000001101100 -> round down
		// 	S=0		E=010		F=11011
		//	S=0		E=2			F=27
		//  V = (-1)^0 x 27 x 2^2 = 108
		D = 13'b0000001101100;	
		#10
		if (S == 1'b0 && E[2:0] == 3'b010 && F[4:0] == 5'b11011)
			$display("Passed: linear input 108");
		else 
			$display("Failed: linear input 108");


		// 109: 0000001101101 -> round down
		// 	S=0		E=010		F=11011
		//	S=0		E=2			F=27
		//  V = (-1)^0 x 27 x 2^2 = 108
		D = 13'b0000001101101;	
		#10
		if (S == 1'b0 && E[2:0] == 3'b010 && F[4:0] == 5'b11011)
			$display("Passed: linear input 109");
		else 
			$display("Failed: linear input 109");


		// ROUND UP (given in spec)

		// 110: 0000001101110 -> round up
		// 	S=0		E=010		F=11100
		//	S=0		E=2			F=28
		//  V = (-1)^0 x 28 x 2^2 = 112
		D = 13'b0000001101110;
		#10
		if (S == 1'b0 && E[2:0] == 3'b010 && F[4:0] == 5'b11100)
			$display("Passed: linear input 110");
		else 
			$display("Failed: linear input 110");

		// 111: 0000001101111 -> round up
		// 	S=0		E=010		F=11100
		//	S=0		E=2			F=28
		//  V = (-1)^0 x 28 x 2^2 = 112
		D = 13'b0000001101111;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b010 && F[4:0] == 5'b11100)
			$display("Passed: linear input 111");
		else 
			$display("Failed: linear input 111");


		// EDGE CASES

		// Most negative number
		// -4096: 1000000000000 -> round up
		// S=1		E=111		F=11111
		// S=1		E=7			F=31
		//  V = (-1)^1 x 31 x 2^7 = -3968
		D = 13'b1000000000000;
		#10;
		if (S == 1'b1 && E[2:0] == 3'b111 && F[4:0] == 5'b11111)
			$display("Passed: linear input -4096");
		else 
			$display("Failed: linear input -4096");

		// Significand & exponent rounding overflow
		// 4095: 0111111111111 -> round up
		// S=0		E=111		F=11111 -> round up, overflow of F & E -> Keep E & F same
		// S=0		E=7			F=31
		//  V = (-1)^0 x 31 x 2^7 = 3968
		D = 13'b0111111111111;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b111 && F[4:0] == 5'b11111)
			$display("Passed: linear input 4095");
		else 
			$display("Failed: linear input 4095");

		// Significand & exponent rounding overflow #2
		// 4032: 0111111000000 -> round up
		// S=0		E=111		F=11111 -> round up, overflow of F & E -> Keep E & F same
		// S=0		E=7			F=31
		//  V = (-1)^0 x 31 x 2^7 = 3968
		D = 13'b0111111000000;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b111 && F[4:0] == 5'b11111)
			$display("Passed: linear input 4032");
		else 
			$display("Failed: linear input 4032");

		// Significand rounding overflow
		// 253: 0000011111101
		// S=0		E=011		F=11111	-> shift right, increment E
		// 			E=100		F=10000
		// S=0		E=4			F=16
		// V = (-1)^0 x 16 x 2^4 = 256
		D = 13'b0000011111101;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b100 && F[4:0] == 5'b10000)
			$display("Passed: linear input 253");
		else 
			$display("Failed: linear input 253");

		
		// OTHER CASES

		// 0:	0000000000000	-> round down
		// S=0		E=000		F=00000
		// S=0		E=0			F=0
		// V = (-1)^(0) x 0 X 2^0 = 0
		D = 13'b0000000000000;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b000 && F[4:0] == 5'b00000)
			$display("Passed: linear input 0");
		else 
			$display("Failed: linear input 0");

		// -1:	1111111111111	-> round up
		// S=1		E=000		F=00001
		// S=1		E=0			F=1
		// V = (-1)^(-1) x 1 X 2^0 = -1
		D = 13'b1111111111111;
		#10;
		if (S == 1'b1 && E[2:0] == 3'b000 && F[4:0] == 5'b00001)
			$display("Passed: linear input -1");
		else 
			$display("Failed: linear input -1");

		D = 13'b0101010101010;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b111 && F[4:0] == 5'b10101)
			$display("Passed: linear input 2730");
		else 
			$display("Failed: linear input 2730");

		D = 13'b1111110111000;
		#10;
		if (S == 1'b1 && E[2:0] == 3'b010 && F[4:0] == 5'b10010)
			$display("Passed: linear input -72");
		else 
			$display("Failed: linear input -72");

		D = 13'b0000001100100;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b010 && F[4:0] == 5'b11001)
			$display("Passed: linear input 100");
		else 
			$display("Failed: linear input 100");

		D = 13'b1011010001011;
		#10;
		if (S == 1'b1 && E[2:0] == 3'b111 && F[4:0] == 5'b10011)
			$display("Passed: linear input -2421");
		else 
			$display("Failed: linear input -2421");

		D = 13'b0000000001111;
		#10;
		if (S == 1'b0 && E[2:0] == 3'b000 && F[4:0] == 5'b01111)
			$display("Passed: linear input 15");
		else 
			$display("Failed: linear input 15");

	end
      
endmodule
