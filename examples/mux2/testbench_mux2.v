`timescale 1ns / 1ps

module testbench_mux2;

	// Inputs
	reg a;
	reg b;
	reg sel;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	mux2 uut (
		.a(a),
		.b(b),
		.sel(sel),
		.out(out)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 1;
		sel = 0;	// Expected: out = 0
		
		// Wait 100 ns for global reset to finish
		#100;
		sel = 1;
		a = 1;
		b = 0;		// Expected: out = 1
        
		// Add stimulus here

	end
      
endmodule
