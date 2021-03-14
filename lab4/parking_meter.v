`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:11:33 03/12/2021 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
    input add1, // add 60 seconds
    input add2, // add 120 seconds
    input add3, // add 180 seconds
    input add4, // add 300 seconds
    input rst1, // reset time to 16 seconds
    input rst2, // reset time to 150 seconds
    input clk,  // frequency of 100 Hz
    input rst,  // resets to initial state 0000
    output reg [6:0] led_seg, // CA (msb) to CG (lsb)
    output reg a1,
    output reg a2,
    output reg a3,
    output reg a4,
    output reg [3:0] val1,
    output reg [3:0] val2,
    output reg [3:0] val3,
    output reg [3:0] val4
    );

    // States (3)
    parameter ZERO = 2'b00;     // time = 0 seconds
    parameter LT_180 = 2'b01;   // 1 second <= time <= 179 seconds
    parameter GTE_180 = 2'b10;  // 180 seconds <= time

    // Data structures
    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [13:0] tm; // max 9999 = 14'b10011100001111
    reg [6:0] count_100; // clk cycle is 0.01s -> count 100 (7'b1100100) clk cycles to get 1s
    reg [1:0] digit_idx; // index of digit to display: 0 (first in refresh period) to 3 (last)
    reg display_on; // display led_seg, a1, a2, a3, a4 if display_on = 1

    // Update current state
    always @ (posedge clk)
    begin
        if (rst) begin
			current_state <= ZERO;
        end else begin
            current_state <= next_state;
		end
    end
    
    // Decide next states
    always @ (*)
    begin
        if (tm == 0)
            next_state = ZERO;
        else if (tm < 180)
            next_state = LT_180;
        else 
            next_state = GTE_180;
    end

    // Update timer
    always @ (posedge clk) // posedge add1, posedge add2, posedge add3, posedge add4, posedge rst1, posedge rst2
    begin
        if (rst) begin
            tm <= 0;
            count_100 <= 0;
            display_on <= 0;
            digit_idx <= 0;
        end else if (add1) begin
            if (tm + 60 < 9999)
                tm <= tm + 60;
            else 
                tm <= 9999;
        end else if (add2) begin
            if (tm + 120 < 9999) 
                tm <= tm + 120;
            else 
                tm <= 9999;
        end else if (add3) begin
            if (tm + 180 < 9999) 
                tm <= tm + 180;
            else 
                tm <= 9999;
        end else if (add4) begin
            if (tm + 300 < 9999) 
                tm <= tm + 300;
            else 
                tm <= 9999;
        end else if (rst1) begin
            tm <= 16;
        end else if (rst2) begin
            tm <= 150;
        end else begin
            if (count_100 == 100) begin
                count_100 <= 0;
                if (tm > 0) tm <= tm - 1;
                else tm <= tm;
            end else begin
                count_100 <= count_100 + 1;
            end
        end

        // Update digit_idx, display_on for output module led_seg, a1, a2, a3, a4
        if (current_state == ZERO) begin    
            // Update digit_idx every 1/4 refresh cycle = 12.5 clk cycles
            if (count_100 <= 12)
                digit_idx <= 0;
            else if (count_100 <= 25)
                digit_idx <= 1;
            else if (count_100 <= 37)
                digit_idx <= 2;
            else if (count_100 <= 50)
                digit_idx <= 3;
            else 
                digit_idx <= 0;
        end
        else begin  
            // LT_180, GTE_180: Update digit_idx every 1/4 refresh cycle = 25 clk cycles
            if (count_100 <= 25)
                digit_idx <= 0;
            else if (count_100 <= 50)
                digit_idx <= 1;
            else if (count_100 <= 75)
                digit_idx <= 2;
            else 
                digit_idx <= 3;            
        end

        // Update display_on
        // ZERO: on for 50 clk cycles, then off for 50
        // LT_180: on for 100 clk cycles, then off for 100
        // GTE_180: on
        if (current_state == ZERO) begin
            if (count_100 <= 50)
                display_on <= 1;
            else 
                display_on <= 0;
        end else if (current_state == LT_180) begin
            if (tm % 2 == 0)
                display_on <= 1;
            else 
                display_on <= 0;
        end else begin // GTE_180
            display_on <= 1;
        end
    end

    // Update outputs
    always @(*)
    begin
        val1 <= tm % 10;
        val2 <= (tm / 10) % 10;
        val3 <= (tm / 100) % 10;
        val4 <= (tm / 1000) % 10;

        a1 <= 0;
        a2 <= 0;
        a3 <= 0;
        a4 <= 0;

        if (display_on) begin
            case (digit_idx)
                0:  begin
                    a1 <= 1;
                    led_seg <= illuminate(val1);
                end
                1:  begin
                    a2 <= 1;
                    led_seg <= illuminate(val2);
                end
                2:  begin
                    a3 <= 1;
                    led_seg <= illuminate(val3);
                end
                3:  begin
                    a4 <= 1;
                    led_seg <= illuminate(val4);
                end
                default: led_seg <= led_seg;
            endcase
        end else begin
            led_seg <= 7'b0000001;
        end
    end

    // Returns seven-segment vector for led_seg corresponding to each digit 0 to 9
    function [6:0] illuminate (input [3:0] digit);
    begin
        case (digit)
            1: illuminate = 7'b1001111;
            2: illuminate = 7'b0010010;
            3: illuminate = 7'b0000110;
            4: illuminate = 7'b1001100;
            5: illuminate = 7'b0100100;
            6: illuminate = 7'b0100000;
            7: illuminate = 7'b0001111;
            8: illuminate = 7'b0000000;
            9: illuminate = 7'b0000100;
            default: illuminate = 7'b0000001; // digit = 0
        endcase
    end 
    endfunction

endmodule