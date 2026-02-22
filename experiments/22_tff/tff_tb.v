// T Flip-Flop Testbench
`timescale 1ns/1ps
module tff_tb;
    reg  clk, rst_n, t;
    wire q;

    tff uut (.clk(clk),.rst_n(rst_n),.t(t),.q(q));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tff.vcd");
        $dumpvars(0, tff_tb);
        clk=0; rst_n=0; t=1; #12; rst_n=1;
        repeat(4) @(posedge clk); #1;
        $display("After 4 toggles q=%b (expect alternating)", q);
        t=0; @(posedge clk); #1;
        // q should not change when t=0
        $display("T Flip-Flop test complete.");
        $finish;
    end
endmodule
