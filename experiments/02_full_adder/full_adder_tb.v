// Full Adder Testbench
`timescale 1ns/1ps
module full_adder_tb;
    reg  a, b, cin;
    wire sum, cout;

    full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg [2:0] expected;

    initial begin
        $dumpfile("full_adder.vcd");
        $dumpvars(0, full_adder_tb);
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i[2:0]; #10;
            expected = a + b + cin;
            if ({cout, sum} !== expected[1:0])
                $display("FAIL: a=%b b=%b cin=%b -> sum=%b cout=%b (exp %b%b)",
                         a, b, cin, sum, cout, expected[1], expected[0]);
        end
        $display("Full adder test complete.");
        $finish;
    end
endmodule
