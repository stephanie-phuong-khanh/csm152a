`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:46:31 02/27/2021 
// Design Name: 
// Module Name:    vending_machine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module vending_machine(
    input CLK, 
    input RESET, 
    input RELOAD, 
    input CARD_IN,
    input [3:0] ITEM_CODE,
    input KEY_PRESS,
    input VALID_TRAN,
    input DOOR_OPEN,
    output reg VEND,
    output reg INVALID_SEL,
    output reg [2:0] COST,
    output reg FAILED_TRAN
);

// STATES (9)
parameter IDLE = 4'b0000;
parameter RELOADING = 4'b0001;
parameter AWAIT_KEY_1 = 4'b0010;
parameter AWAIT_KEY_2 = 4'b0011;
parameter INVALID_SELECTION = 4'b0100;
parameter AWAIT_VALID_TRAN = 4'b0101;
parameter FAILURE = 4'b0110;
parameter VENDING = 4'b0111;
parameter DOOR_OPENED = 4'b1000;

// VARIABLES
reg [3:0] snack_counters [19:0];
reg [3:0] snack_counters_next [19:0];
reg [3:0] digits_tens;
reg [4:0] selection_digits;
reg [2:0] count_to_five;
reg [3:0] current_state;
reg [3:0] next_state;
reg hold;
integer i;

// Update state : sequential - triggered by clock
always @ (posedge CLK)
begin
    if (RESET) begin
        // ouputs to 0, counters to 0, go to IDLE state
        current_state <= IDLE;
        for (i = 0; i < 20; i = i+1) begin
            snack_counters[i] = 0;
        end
    end else begin
        if (current_state == next_state
            && (current_state == AWAIT_KEY_1 
                || current_state == AWAIT_KEY_2 
                || current_state == AWAIT_VALID_TRAN
                || current_state == VENDING && !DOOR_OPEN
                ))
            count_to_five = count_to_five + 1'b1;
        else 
            count_to_five = 0;

        current_state <= next_state;
        for (i = 0; i < 20; i = i+1) begin
            snack_counters[i] = snack_counters_next[i];
        end
    end
end


// Decide next_state : combinational - triggered by state/input
always @(*) 
begin
    case (current_state)
        IDLE: begin
            if (CARD_IN) next_state = AWAIT_KEY_1;
            else if (RELOAD) next_state = RELOADING;
            else next_state = IDLE;
        end
        RELOADING: begin
            if (RELOAD) next_state = RELOADING;
            else next_state = IDLE;
        end
        AWAIT_KEY_1: begin
            if (count_to_five >= 4) begin
                next_state = IDLE;
            end
            if (KEY_PRESS) begin
                digits_tens = ITEM_CODE;
                hold = 0;
                next_state = AWAIT_KEY_2;
            end else if (next_state == AWAIT_KEY_2)
                hold = 1;
        end
        AWAIT_KEY_2: begin
            if (count_to_five >= 4) begin
                next_state = IDLE;
            end
            if (!KEY_PRESS)
                hold = 1;
            else if (KEY_PRESS && hold) begin
                if ((digits_tens == 0 || digits_tens == 1) 
                    && (0 <= ITEM_CODE && ITEM_CODE <= 9)
                    && snack_counters[(digits_tens * 10) + ITEM_CODE] > 0) begin
                        next_state = AWAIT_VALID_TRAN;
                        selection_digits = (10 * digits_tens) + ITEM_CODE;
                    end
                else
                    next_state = INVALID_SELECTION;
            end
        end
        INVALID_SELECTION:
            next_state = IDLE;
        AWAIT_VALID_TRAN: begin
            if (count_to_five >= 4) begin
                next_state = FAILURE;
            end else if (VALID_TRAN) begin
                next_state = VENDING;
            end else begin
                next_state = AWAIT_VALID_TRAN;
            end
        end
        FAILURE:
            next_state = IDLE;
        VENDING: begin
            if (DOOR_OPEN) begin
                next_state = DOOR_OPENED;
            end else if (count_to_five >= 4) begin
                next_state = IDLE;
            end else 
                next_state = VENDING;
        end
        DOOR_OPENED: begin
            if (DOOR_OPEN) begin
                next_state = DOOR_OPENED;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end


// Decide outputs : triggered by state/inputs; can be comb/ seq.
always @(*)
begin
    if (RESET) begin
        for (i = 0; i < 20; i = i+1)
            snack_counters_next[i] = 0;
    end

    VEND = 0;
    INVALID_SEL = 0;
    COST = 0;
    FAILED_TRAN = 0;
    
    case (current_state)
        RELOADING: begin
            for (i = 0; i < 20; i = i+1)
                snack_counters_next[i] = 10;  
        end
        INVALID_SELECTION:
            INVALID_SEL = 1;
        AWAIT_VALID_TRAN: begin
            if (0 <= selection_digits && selection_digits <= 3) COST = 1;
            else if (4 <= selection_digits && selection_digits <= 7) COST = 2;
            else if (8 <= selection_digits && selection_digits <= 11) COST = 3;
            else if (12 <= selection_digits && selection_digits <= 15) COST = 4;
            else if (16 <= selection_digits && selection_digits <= 17) COST = 5;
            else if (18 <= selection_digits && selection_digits <= 19) COST = 6;
            else COST = 0;
        end
        FAILURE:
            FAILED_TRAN = 1;
        VENDING: begin
            snack_counters_next[selection_digits] = snack_counters_next[selection_digits] - 1;
            VEND = 1;
        end
        DOOR_OPENED: 
            VEND = 0;
        default: begin
            VEND = 0;
            INVALID_SEL = 0;
            COST = 0;
            FAILED_TRAN = 0;
        end
    endcase
end

endmodule
