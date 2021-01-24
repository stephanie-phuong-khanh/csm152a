// 3-bit counter

module counter(out, clk, rst);

    input wire clk, rst;
    output reg [2:0] out;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            out <= 6'b000;
        else 
            out <= out + 1;
    end

endmodule