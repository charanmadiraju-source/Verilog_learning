// Testbench: Experiment 7 – Half Adder
`timescale 1ns/1ps
module half_adder_tb;
    reg  a, b;
    wire sum, carry;

    half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));

    integer errors = 0;

    initial begin
        $dumpfile("half_adder.vcd");
        $dumpvars(0, half_adder_tb);

        {a, b} = 2'b00; #10;
        if (sum !== 1'b0 || carry !== 1'b0) begin $display("FAIL: a=%b b=%b sum=%b carry=%b", a, b, sum, carry); errors = errors + 1; end
        {a, b} = 2'b01; #10;
        if (sum !== 1'b1 || carry !== 1'b0) begin $display("FAIL: a=%b b=%b sum=%b carry=%b", a, b, sum, carry); errors = errors + 1; end
        {a, b} = 2'b10; #10;
        if (sum !== 1'b1 || carry !== 1'b0) begin $display("FAIL: a=%b b=%b sum=%b carry=%b", a, b, sum, carry); errors = errors + 1; end
        {a, b} = 2'b11; #10;
        if (sum !== 1'b0 || carry !== 1'b1) begin $display("FAIL: a=%b b=%b sum=%b carry=%b", a, b, sum, carry); errors = errors + 1; end

        if (errors == 0)
            $display("PASS: Half adder test complete.");
        else
            $display("FAIL: %0d error(s) detected.", errors);
        $finish;
    end
endmodule
