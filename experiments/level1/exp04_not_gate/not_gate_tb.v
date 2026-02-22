// Testbench: Experiment 4 – NOT / Inverter Gate
`timescale 1ns/1ps
module not_gate_tb;
    reg  a;
    wire y;

    not_gate uut (.a(a), .y(y));

    integer errors = 0;

    initial begin
        $dumpfile("not_gate.vcd");
        $dumpvars(0, not_gate_tb);

        a=0; #10; if (y !== 1'b1) begin $display("FAIL: a=%b y=%b", a, y); errors = errors + 1; end
        a=1; #10; if (y !== 1'b0) begin $display("FAIL: a=%b y=%b", a, y); errors = errors + 1; end

        if (errors == 0)
            $display("PASS: NOT gate test complete.");
        else
            $display("FAIL: %0d error(s) detected.", errors);
        $finish;
    end
endmodule
