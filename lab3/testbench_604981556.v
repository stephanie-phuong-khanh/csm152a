`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:47:00 02/27/2021
// Design Name:   vending_machine
// Module Name:   /home/ise/xilinx/lab3/testbench_604981556.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
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
	reg CLK;
	reg RESET;
	reg RELOAD;
	reg CARD_IN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg VALID_TRAN;
	reg DOOR_OPEN;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire [2:0] COST;
	wire FAILED_TRAN;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		// input
		.CLK(CLK), 
		.RESET(RESET), 
		.RELOAD(RELOAD), 
		.CARD_IN(CARD_IN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.VALID_TRAN(VALID_TRAN), 
		.DOOR_OPEN(DOOR_OPEN), 
		// output
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.COST(COST), 
		.FAILED_TRAN(FAILED_TRAN)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		RESET = 0;
		RELOAD = 0;
		CARD_IN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		VALID_TRAN = 0;
		DOOR_OPEN = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset();
		reloading();
		timeout_no_keypress_1();
		timeout_no_keypress_2();
		timeout_no_door_open();
		invalid_selection();
		door_stays_open();
		invalid_transaction();
		empty_snacks();
		successful_vend();
		
	end

task pos_edge; begin
	CLK <= 1;
	#5;
end endtask

task neg_edge; begin
	CLK <= 0;
	#5;
end endtask

////////////////////////////
////////////////////////////


task reset; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Reset");
	else 
		$display("Failed: Resest");
end endtask


task reloading; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	// if (snack_counters_0 != 0 || snack_counters_1 != 0
	// 	|| snack_counters_2 != 0 || snack_counters_3 != 0
	// 	|| snack_counters_4 != 0 || snack_counters_5 != 0
	// 	|| snack_counters_6 != 0 || snack_counters_7 != 0
	// 	|| snack_counters_8 != 0 || snack_counters_9 != 0
	// 	|| snack_counters_10 != 0 || snack_counters_11 != 0
	// 	|| snack_counters_12 != 0 || snack_counters_13 != 0
	// 	|| snack_counters_14 != 0 || snack_counters_15 != 0
	// 	|| snack_counters_16 != 0 || snack_counters_17 != 0
	// 	|| snack_counters_18 != 0 || snack_counters_19 != 0)
	// 	$display("Failed: First reset does not make snack counters 0");

	pos_edge();		RELOAD = 1;		neg_edge();
	pos_edge();		RELOAD = 0;		neg_edge();
	pos_edge();		neg_edge();

	// if (snack_counters_0 != 10 || snack_counters_1 != 10
	// 	|| snack_counters_2 != 10 || snack_counters_3 != 10
	// 	|| snack_counters_4 != 10 || snack_counters_5 != 10
	// 	|| snack_counters_6 != 10 || snack_counters_7 != 10
	// 	|| snack_counters_8 != 10 || snack_counters_9 != 10
	// 	|| snack_counters_10 != 10 || snack_counters_11 != 10
	// 	|| snack_counters_12 != 10 || snack_counters_13 != 10
	// 	|| snack_counters_14 != 10 || snack_counters_15 != 10
	// 	|| snack_counters_16 != 10 || snack_counters_17 != 10
	// 	|| snack_counters_18 != 10 || snack_counters_19 != 10)
	// 	$display("Failed: Reload does not make snack counters 10");

	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();

	// if (snack_counters_0 != 0 || snack_counters_1 != 0
	// 	|| snack_counters_2 != 0 || snack_counters_3 != 0
	// 	|| snack_counters_4 != 0 || snack_counters_5 != 0
	// 	|| snack_counters_6 != 0 || snack_counters_7 != 0
	// 	|| snack_counters_8 != 0 || snack_counters_9 != 0
	// 	|| snack_counters_10 != 0 || snack_counters_11 != 0
	// 	|| snack_counters_12 != 0 || snack_counters_13 != 0
	// 	|| snack_counters_14 != 0 || snack_counters_15 != 0
	// 	|| snack_counters_16 != 0 || snack_counters_17 != 0
	// 	|| snack_counters_18 != 0 || snack_counters_19 != 0)
	// 	$display("Failed: Second reset does not make snack counters 0");
	
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Reloading test");
	else 
		$display("Failed: Reloading test");
end endtask


task timeout_no_keypress_1; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		CARD_IN = 0;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Timeout from no first key press");
	else 
		$display("Failed: Timeout from no first key press");
end endtask


task timeout_no_keypress_2; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 1;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		CARD_IN = 0;	KEY_PRESS = 0;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Timeout from no second key press");
	else 
		$display("Failed: Timeout from no second key press");
end endtask

task timeout_no_door_open; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		RELOAD = 1;		neg_edge();
	pos_edge();		RELOAD = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 0;  CARD_IN = 0;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 9;	neg_edge();
	pos_edge();		VALID_TRAN = 1;	neg_edge();
	pos_edge();		neg_edge();

	if (VEND != 1)
		$display("FAILED: VEND not set to 1");
	
	pos_edge();		VALID_TRAN = 0;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();

	// Should go back to idle, so current_state = 4'b0000
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Timeout from no door open");
	else 
		$display("Failed: Timeout from no door open");
end endtask

task invalid_selection; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 9;	neg_edge();
	pos_edge();		KEY_PRESS = 0;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 9;	neg_edge();
	pos_edge();		CARD_IN = 0;	KEY_PRESS = 0;	neg_edge();

	#10;
	if (VEND == 0 && INVALID_SEL == 1 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Invalid selection number");
	else 
		$display("Failed: Invalid selection number");
end endtask


task door_stays_open; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		RELOAD = 1;		neg_edge();
	pos_edge();		RELOAD = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 0;  CARD_IN = 0;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 9;	neg_edge();
	pos_edge();		VALID_TRAN = 1;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		VALID_TRAN = 0;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		DOOR_OPEN = 1;	neg_edge();
	pos_edge();		neg_edge();

	// current_state should stay at DOOR_OPENED = 4'b1000
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Door stays open");
	else 
		$display("Failed: Door stays open");
end endtask


task invalid_transaction; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		RELOAD = 1;		neg_edge();
	pos_edge();		RELOAD = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 0;  CARD_IN = 0;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 9;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		neg_edge();

	// current_state should be at FAILURE = 4'b0110
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 1)
		$display("Passed: Invalid transaction");
	else 
		$display("Failed: Invalid transaction");
end endtask


task empty_snacks(); begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 0;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 2;	neg_edge();
	pos_edge();		CARD_IN = 0;	KEY_PRESS = 0;	neg_edge();

	#10;
	if (VEND == 0 && INVALID_SEL == 1 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Empty snacks");
	else 
		$display("Failed: Empty snacks");
end endtask


task successful_vend; begin
	pos_edge();		RESET = 1;		neg_edge();
	pos_edge();		RESET = 0;		neg_edge();
	pos_edge();		RELOAD = 1;		neg_edge();
	pos_edge();		RELOAD = 0;		neg_edge();
	pos_edge();		CARD_IN = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 1;	neg_edge();
	pos_edge();		KEY_PRESS = 0;  CARD_IN = 0;	neg_edge();
	pos_edge();		KEY_PRESS = 1;	ITEM_CODE = 9;	neg_edge();
	pos_edge();		VALID_TRAN = 1;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		VALID_TRAN = 0;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		DOOR_OPEN = 1;	neg_edge();
	pos_edge();		neg_edge();
	pos_edge();		DOOR_OPEN = 0;	neg_edge();
	pos_edge();		neg_edge();

	// current_state should go back to IDLE = 4'b0000
	// snack_counters_19 should have value 19 = 4'b1001
	#10;
	if (VEND == 0 && INVALID_SEL == 0 && COST == 0 && FAILED_TRAN == 0)
		$display("Passed: Successful vend");
	else 
		$display("Failed: Successful vend");
end endtask

endmodule
