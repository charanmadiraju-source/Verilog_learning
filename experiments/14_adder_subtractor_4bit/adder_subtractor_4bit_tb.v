// 4-Bit Adder-Subtractor Testbench
`timescale 1ns/1ps
module adder_subtractor_4bit_tb;
    reg  [3:0] a, b;
    reg  mode;
    wire [3:0] result;
    wire cout;

    adder_subtractor_4bit uut (.a(a),.b(b),.mode(mode),.result(result),.cout(cout));

    reg [4:0] expected;
    integer i, j;

    initial begin
        $dumpfile("adder_subtractor_4bit.vcd");
        $dumpvars(0, adder_subtractor_4bit_tb);
        // Addition
        mode = 0;
        for (i = 0; i < 16; i = i + 1) for (j = 0; j < 16; j = j + 1) begin
            a=i[3:0]; b=j[3:0]; #5;
            expected = a + b;
            if ({cout,result} !== expected) $display("ADD FAIL %0d+%0d",a,b);
        end
        // Subtraction
        mode = 1;
        for (i = 0; i < 16; i = i + 1) for (j = 0; j < 16; j = j + 1) begin
            a=i[3:0]; b=j[3:0]; #5;
            expected = {1'b0,a} - {1'b0,b};
            if (result !== expected[3:0]) $display("SUB FAIL %0d-%0d",a,b);
        end
        $display("Adder-Subtractor test complete.");
        $finish;
    end
endmodule
