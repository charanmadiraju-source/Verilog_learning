// D Flip-Flop Testbench
`timescale 1ns/1ps
module dff_tb;
    reg  clk, rst_n, d;
    wire q;

    dff uut (.clk(clk),.rst_n(rst_n),.d(d),.q(q));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0, dff_tb);
        clk=0; rst_n=0; d=0; #12;
        rst_n=1; d=1; @(posedge clk); #1;
        if (q!==1) $display("FAIL: expected q=1");
        d=0; @(posedge clk); #1;
        if (q!==0) $display("FAIL: expected q=0");
        rst_n=0; #3;
        if (q!==0) $display("FAIL: async reset");
        $display("D Flip-Flop test complete.");
        $finish;
    end
endmodule
