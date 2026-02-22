// 4-Bit Multiplier Testbench
`timescale 1ns/1ps
module multiplier_4bit_tb;
    reg  [3:0] a, b;
    wire [7:0] product;

    multiplier_4bit uut (.a(a),.b(b),.product(product));

    integer i, j;
    initial begin
        $dumpfile("multiplier_4bit.vcd");
        $dumpvars(0, multiplier_4bit_tb);
        for (i = 0; i < 16; i = i + 1)
            for (j = 0; j < 16; j = j + 1) begin
                a=i[3:0]; b=j[3:0]; #5;
                if (product !== i*j)
                    $display("FAIL: %0d * %0d = %0d (got %0d)", i, j, i*j, product);
            end
        $display("4-Bit Multiplier test complete.");
        $finish;
    end
endmodule
