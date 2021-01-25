E[2:0] = 3'b000;
F[4:0] = 5'b00000;
round_bit = 1'b0; 
casex (sign_magnitude[12:5])
    {8'b00000000}: 
    begin
        E[2:0] = 3'b000;
        F[4:0] = sign_magnitude[4:0];
        round_bit = 1'b0;
    end

    8'b0000000x: 
    begin
        E[2:0] = 3'b001;
        F[4:0] = sign_magnitude[5:1];
        round_bit = sign_magnitude[0];
    end

    8'b000000xx: 
    begin
        E[2:0] = 3'b010;
        F[4:0] = sign_magnitude[6:2];
        round_bit = sign_magnitude[1];
    end

    8'b00000xxx: 
    begin
        E[2:0] = 3'b011;
        F[4:0] = sign_magnitude[7:3];
        round_bit = sign_magnitude[2];
    end

    8'b0000xxxx: 
    begin
        E[2:0] = 3'b100;
        F[4:0] = sign_magnitude[8:4];
        round_bit = sign_magnitude[3];
    end

    8'b000xxxxx:
    begin
        E[2:0] = 3'b101;
        F[4:0] = sign_magnitude[9:5];
        round_bit = sign_magnitude[4];
    end

    8'b00xxxxxx:
    begin
        E[2:0] = 3'b110;
        F[4:0] = sign_magnitude[10:6];
        round_bit = sign_magnitude[5];
    end

    8'b0xxxxxxx:
    begin
        E[2:0] = 3'b111;
        F[4:0] = sign_magnitude[11:7];
        round_bit = sign_magnitude[6];
    end

endcase







E[2:0] = 3'b000;
if (sign_magnitude[12:5] == 8'b00000000)
    E[2:0] = 3'b000;
else if (sign_magnitude[12:6] == 7'b0000000)
    E[2:0] = 3'b001;
else if (sign_magnitude[12:7] == 6'b000000)
    E[2:0] = 3'b010;
else if (sign_magnitude[12:8] == 5'b00000)
    E[2:0] = 3'b011;
else if (sign_magnitude[12:9] == 4'b0000)
    E[2:0] = 3'b100;
else if (sign_magnitude[12:10] == 3'b000)
    E[2:0] = 3'b101;
else if (sign_magnitude[12:11] == 2'b00)
    E[2:0] = 3'b110;
else if (sign_magnitude[12] == 1'b0)
    E[2:0] = 3'b111;




// EXTRA

D = 13'b0000010111000;
#10
if (S == 1'b0 && E[2:0] == 3'b011 && F[4:0] == 5'b10111)
    $display("Passed: linear input 184");
else 
    $display("Failed: linear input 184");

D = 13'b1000011111100;
#10
if (S == 1'b1 && E[2:0] == 3'b111 && F[4:0] == 5'b11110)
    $display("Passed: linear input -3844");
else 
    $display("Failed: linear input -3844");

D = 13'b0000011111100;
#10
if (S == 1'b0 && E[2:0] == 3'b100 && F[4:0] == 5'b10000)
    $display("Passed: linear input 252");
else 
    $display("Failed: linear input 252");

D = 13'b1111100000010;
#10;
if (S == 1'b1 && E[2:0] == 3'b100 && F[4:0] == 5'b10000)
    $display("Passed: linear input -254");
else 
    $display("Failed: linear input -254");