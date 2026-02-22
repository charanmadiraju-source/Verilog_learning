// 4-Bit Ripple Carry Adder Testbench
`timescale 1ns/1ps
module ripple_carry_adder_4bit_tb;
    reg  [3:0] a, b;
    reg  cin;
    wire [3:0] sum;
    wire cout;

    ripple_carry_adder_4bit uut (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));

    integer i, j;
    reg [4:0] expected;

    initial begin
        $dumpfile("ripple_carry_adder_4bit.vcd");
        $dumpvars(0, ripple_carry_adder_4bit_tb);
        cin = 0;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i[3:0]; b = j[3:0]; #5;
                expected = a + b + cin;
                if ({cout,sum} !== expected)
                    $display("FAIL: %0d + %0d = %0d (got %0d)", a, b, expected, {cout,sum});
            end
        end
        $display("4-Bit Ripple Carry Adder test complete.");
        $finish;
    end
endmodule
