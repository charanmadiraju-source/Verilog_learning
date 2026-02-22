// Testbench: Experiment 3 – 2-Input OR Gate (Behavioral)
`timescale 1ns/1ps
module or_gate_tb;
    reg  a, b;
    wire y;

    or_gate uut (.a(a), .b(b), .y(y));

    integer errors = 0;

    initial begin
        $dumpfile("or_gate.vcd");
        $dumpvars(0, or_gate_tb);

        a=0; b=0; #10; if (y !== 1'b0) begin $display("FAIL: a=%b b=%b y=%b", a, b, y); errors = errors + 1; end
        a=0; b=1; #10; if (y !== 1'b1) begin $display("FAIL: a=%b b=%b y=%b", a, b, y); errors = errors + 1; end
        a=1; b=0; #10; if (y !== 1'b1) begin $display("FAIL: a=%b b=%b y=%b", a, b, y); errors = errors + 1; end
        a=1; b=1; #10; if (y !== 1'b1) begin $display("FAIL: a=%b b=%b y=%b", a, b, y); errors = errors + 1; end

        if (errors == 0)
            $display("PASS: OR gate test complete.");
        else
            $display("FAIL: %0d error(s) detected.", errors);
        $finish;
    end
endmodule
