`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Stephanie Doan
// 
// Create Date:    07:54:05 01/23/2021 
// Design Name: 
// Module Name:    FPCVT 
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

module FPCVT(D, S, E, F);

    input wire [12:0] D;
    output reg S; 
    output reg [2:0] E;
    output reg [4:0] F;

    reg [12:0] sign_magnitude;
    reg round_bit; // 6th bit after last leading 0: 1 = round significand up, 0 = round down

    always @* 
    begin

        // BLOCK 1: Two's complement to sign magnitude
        S = D[12];  // Extract sign bit
        // Convert 2's-complement to sign-magnitude
        if (S == 1'b0) // Positive number -> same value
            sign_magnitude[12:0] = D[12:0];
        else if (D[12:0] == 13'b1000000000000)
            sign_magnitude[12:0] = 13'b1111111111111;
        else // Negative number -> invert, add 1 
            sign_magnitude[12:0] = ~D[12:0] + 1'b1;


        // BLOCK 2: Linear to FP: fill values for exponent, significand, round bit
        E[2:0] = 3'b111;
        F[4:0] = 5'b11111;
        round_bit = 1'b0; 
        if (sign_magnitude[12:5] == 8'b00000000)
            begin
                E[2:0] = 3'b000;
                F[4:0] = sign_magnitude[4:0];
                round_bit = 1'b0;
            end
        else if (sign_magnitude[12:6] == 7'b0000000) 
            begin
                E[2:0] = 3'b001;
                F[4:0] = sign_magnitude[5:1];
                round_bit = sign_magnitude[0];
            end
        else if (sign_magnitude[12:7] == 6'b000000) 
            begin
                E[2:0] = 3'b010;
                F[4:0] = sign_magnitude[6:2];
                round_bit = sign_magnitude[1];
            end
        else if (sign_magnitude[12:8] == 5'b00000) 
            begin
                E[2:0] = 3'b011;
                F[4:0] = sign_magnitude[7:3];
                round_bit = sign_magnitude[2];
            end
        else if (sign_magnitude[12:9] == 4'b0000) 
            begin
                E[2:0] = 3'b100;
                F[4:0] = sign_magnitude[8:4];
                round_bit = sign_magnitude[3];
            end
        else if (sign_magnitude[12:10] == 3'b000)
            begin
                E[2:0] = 3'b101;
                F[4:0] = sign_magnitude[9:5];
                round_bit = sign_magnitude[4];
            end
        else if (sign_magnitude[12:11] == 2'b00)
            begin
                E[2:0] = 3'b110;
                F[4:0] = sign_magnitude[10:6];
                round_bit = sign_magnitude[5];
            end
        else if (sign_magnitude[12] == 1'b0)
            begin
                E[2:0] = 3'b111;
                F[4:0] = sign_magnitude[11:7];
                round_bit = sign_magnitude[6];
            end

        // BLOCK 3: Round significand (F) according to round bit
        if (round_bit == 1'b1)  // Round up 
        begin
            if (F[4:0] == 5'b11111) // Significand overflow
            begin
                if (E[2:0] == 3'b111) // Exponent overflow
                    begin
                        F[4:0] = 5'b11111;
                        E[2:0] = 3'b111;
                    end
                else // No exponent overflow
                    begin
                        F[4:0] = 5'b10000;
                        E[2:0] = E[2:0] + 1'b1;
                    end
            end
            else
                F[4:0] = F[4:0] + 1'b1;
                E[2:0] = E[2:0];
        end
        else // Round down
            F[4:0] = F[4:0]; 
            E[2:0] = E[2:0];   

    end

endmodule
