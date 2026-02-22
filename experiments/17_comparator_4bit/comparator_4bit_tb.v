// 4-Bit Comparator Testbench
`timescale 1ns/1ps
module comparator_4bit_tb;
    reg  [3:0] a, b;
    wire gt, eq, lt;

    comparator_4bit uut (.a(a),.b(b),.gt(gt),.eq(eq),.lt(lt));

    integer i, j;
    initial begin
        $dumpfile("comparator_4bit.vcd");
        $dumpvars(0, comparator_4bit_tb);
        for (i = 0; i < 16; i = i + 1)
            for (j = 0; j < 16; j = j + 1) begin
                a=i[3:0]; b=j[3:0]; #5;
                if (gt !== (a>b) || eq !== (a==b) || lt !== (a<b))
                    $display("FAIL: a=%0d b=%0d", a, b);
            end
        $display("4-Bit Comparator test complete.");
        $finish;
    end
endmodule
