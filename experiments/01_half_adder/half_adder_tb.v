// Half Adder Testbench
`timescale 1ns/1ps
module half_adder_tb;
    reg  a, b;
    wire sum, carry;

    half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));

    initial begin
        $dumpfile("half_adder.vcd");
        $dumpvars(0, half_adder_tb);
        // Test all combinations
        {a, b} = 2'b00; #10;
        if (sum !== 1'b0 || carry !== 1'b0) $display("FAIL: a=%b b=%b", a, b);
        {a, b} = 2'b01; #10;
        if (sum !== 1'b1 || carry !== 1'b0) $display("FAIL: a=%b b=%b", a, b);
        {a, b} = 2'b10; #10;
        if (sum !== 1'b1 || carry !== 1'b0) $display("FAIL: a=%b b=%b", a, b);
        {a, b} = 2'b11; #10;
        if (sum !== 1'b0 || carry !== 1'b1) $display("FAIL: a=%b b=%b", a, b);
        $display("Half adder test complete.");
        $finish;
    end
endmodule
