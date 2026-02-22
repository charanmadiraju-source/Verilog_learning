// 4-Bit CLA Adder Testbench
`timescale 1ns/1ps
module cla_adder_4bit_tb;
    reg  [3:0] a, b;
    reg  cin;
    wire [3:0] sum;
    wire cout;

    cla_adder_4bit uut (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));

    integer i, j;
    reg [4:0] expected;

    initial begin
        $dumpfile("cla_adder_4bit.vcd");
        $dumpvars(0, cla_adder_4bit_tb);
        for (cin = 0; cin < 2; cin = cin + 1)
            for (i = 0; i < 16; i = i + 1)
                for (j = 0; j < 16; j = j + 1) begin
                    a = i[3:0]; b = j[3:0]; #5;
                    expected = a + b + cin;
                    if ({cout,sum} !== expected)
                        $display("FAIL: %0d+%0d+%0d=%0d got %0d",a,b,cin,expected,{cout,sum});
                end
        $display("4-Bit CLA Adder test complete.");
        $finish;
    end
endmodule
