// 2:1 mux

module mux(a, b, sel, out
        );
    input wire a, b, sel;
    output reg out;

always @* 
begin
    case (sel)
        0: out=a&b;
        1: out=a|b;
    endcase
end

endmodule
