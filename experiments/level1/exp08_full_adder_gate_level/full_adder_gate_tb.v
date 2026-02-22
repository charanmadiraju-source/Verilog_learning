// Testbench: Experiment 8 – Full Adder (Gate-Level)
`timescale 1ns/1ps
module full_adder_gate_tb;
    reg  a, b, cin;
    wire sum, cout;

    full_adder_gate uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer errors = 0;
    integer i;

    initial begin
        $dumpfile("full_adder_gate.vcd");
        $dumpvars(0, full_adder_gate_tb);

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i[2:0]; #10;
            if ({cout, sum} !== (a + b + cin)) begin
                $display("FAIL: a=%b b=%b cin=%b sum=%b cout=%b", a, b, cin, sum, cout);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("PASS: Full adder (gate-level) test complete.");
        else
            $display("FAIL: %0d error(s) detected.", errors);
        $finish;
    end
endmodule
