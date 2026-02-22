// 4-Bit Subtractor Testbench
`timescale 1ns/1ps
module subtractor_4bit_tb;
    reg  [3:0] a, b;
    reg  bin;
    wire [3:0] diff;
    wire bout;

    subtractor_4bit uut (.a(a),.b(b),.bin(bin),.diff(diff),.bout(bout));

    integer i, j;
    reg [4:0] expected;

    initial begin
        $dumpfile("subtractor_4bit.vcd");
        $dumpvars(0, subtractor_4bit_tb);
        bin = 0;
        for (i = 0; i < 16; i = i + 1)
            for (j = 0; j < 16; j = j + 1) begin
                a = i[3:0]; b = j[3:0]; #5;
                expected = {1'b0,a} - {1'b0,b};
                if (diff !== expected[3:0] || bout !== expected[4])
                    $display("FAIL: %0d - %0d", a, b);
            end
        $display("4-Bit Subtractor test complete.");
        $finish;
    end
endmodule
