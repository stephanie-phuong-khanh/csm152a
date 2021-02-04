`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Stephanie Doan
// 
// Create Date:    06:21:44 02/04/2021 
// Design Name: 
// Module Name:    clock_gen 
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

module clock_gen(
    input clk_in,
    input rst,
    output clk_div_2,
    output clk_div_4,
    output clk_div_8,
    output clk_div_16,
    output clk_div_28,
    output clk_div_5,
    output [7:0] toggle_counter
);

clock_div_two task_one(
	.clk_in	(clk_in),
	.rst	(rst),
	.clk_div_2(clk_div_2),
	.clk_div_4(clk_div_4),
	.clk_div_8(clk_div_8),
	.clk_div_16(clk_div_16)
);

clock_div_twenty_eight task_two(
	.clk_in	(clk_in),
	.rst	(rst),
	.clk_div_28(clk_div_28)
);

clock_div_five task_three(
	.clk_in	(clk_in),
	.rst	(rst),
	.clk_div_5(clk_div_5)
);

clock_strobe task_four(
	.clk_in	(clk_in),
	.rst	(rst),
	.toggle_counter (toggle_counter)
);

endmodule

// Clock divider by power of 2s
module clock_div_two(
	input wire clk_in, 
    input wire rst, 
    output reg clk_div_2, 
    output reg clk_div_4, 
    output reg clk_div_8, 
    output reg clk_div_16
);

    reg[3:0] count; // count by 2s at posedges
    always @ (posedge clk_in)
    begin
        if (rst)
            count <= 4'b0000;
        else 
            count <= count + 1'b1;
    end

    always @ (count)
    begin
        clk_div_2 <= count[0];
        clk_div_4 <= count[1];
        clk_div_8 <= count[2]; 
        clk_div_16 <= count[3];
    end

endmodule

// Even division clock using counters
module clock_div_twenty_eight(
	input wire clk_in, 
    input wire rst, 
    output reg clk_div_28
);

    reg[3:0] count = 4'b0000; // count by 2s at posedges
    always @ (posedge clk_in)
    begin
        if (rst)
        begin
            count <= 4'b0000;
            clk_div_28 <= 1'b0;
        end
        else if (count == 4'b1101)   // every 28/2 = 14 positive edges
        begin
            count <= 4'b0000;
            clk_div_28 <= ~clk_div_28;
        end
        else
            count <= count + 1'b1;
    end

endmodule

// Odd division clock using counters
module clock_div_five (
	input wire clk_in, 
    input wire rst, 
    output reg clk_div_5
);

    reg[2:0] count = 3'b000; // count by 1 at posedge and negedge
    always @ (posedge clk_in or negedge clk_in)
    begin
        if (rst)
        begin
            count <= 3'b000;
            clk_div_5 <= 1'b0;
        end  
        else if (count == 3'b100)
        begin
            count <= 3'b000;
            clk_div_5 <= ~clk_div_5;
        end
        else
            count <= count + 1'b1;
    end

endmodule

// Pulse/strobes
module clock_strobe (
	input wire clk_in, 
    input wire rst, 
    output reg [7:0] toggle_counter
);

    reg[1:0] strobe = 2'b00; // divide-by-4 strobe
    always @ (posedge clk_in)
    begin
        if (rst)
        begin
            strobe <= 2'b00; 
            toggle_counter <= 8'b00000000;
        end
        else
        begin
            toggle_counter <= toggle_counter + 2'b10;
            if (strobe == 2'b11)    // subtract 5 on every strobe
            begin
                toggle_counter <= toggle_counter - 3'b101;
                strobe <= 2'b00;
            end
            else 
                strobe <= strobe + 1'b1;
        end
    end

endmodule
