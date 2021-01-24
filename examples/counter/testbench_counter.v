module testbench_counter;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [2:0] out;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.clk(clk),
		.rst(rst),
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		
		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
        
		// Add stimulus here
		#100;
		rst = 0;

	end

	always begin
		#5 clk = ~clk;
	end
      
endmodule
