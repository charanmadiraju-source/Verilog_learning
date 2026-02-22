// 16-Bit Barrel Shifter Testbench
`timescale 1ns/1ps
module barrel_shifter_16bit_tb;
    reg  [15:0] in;
    reg  [3:0]  shamt;
    reg  dir;
    wire [15:0] out;

    barrel_shifter_16bit uut (.in(in),.shamt(shamt),.dir(dir),.out(out));

    integer i;
    initial begin
        $dumpfile("barrel_shifter_16bit.vcd");
        $dumpvars(0, barrel_shifter_16bit_tb);
        in = 16'hA5C3;
        // Left shifts
        dir = 0;
        for (i = 0; i < 16; i = i + 1) begin
            shamt = i[3:0]; #5;
            if (out !== (in << i))
                $display("FAIL left shift %0d: out=%h exp=%h", i, out, in<<i);
        end
        // Right shifts
        dir = 1;
        for (i = 0; i < 16; i = i + 1) begin
            shamt = i[3:0]; #5;
            if (out !== (in >> i))
                $display("FAIL right shift %0d: out=%h exp=%h", i, out, in>>i);
        end
        $display("Barrel Shifter test complete.");
        $finish;
    end
endmodule
