// SR Flip-Flop Testbench
`timescale 1ns/1ps
module srff_tb;
    reg  clk, rst_n, s, r;
    wire q;

    srff uut (.clk(clk),.rst_n(rst_n),.s(s),.r(r),.q(q));

    task apply;
        input si, ri;
        begin s=si; r=ri; @(posedge clk); #1; end
    endtask

    always #5 clk = ~clk;

    initial begin
        $dumpfile("srff.vcd");
        $dumpvars(0, srff_tb);
        clk=0; rst_n=0; s=0; r=0; #12; rst_n=1;
        apply(1,0); if(q!==1) $display("FAIL: set");
        apply(0,0); if(q!==1) $display("FAIL: hold");
        apply(0,1); if(q!==0) $display("FAIL: reset");
        $display("SR Flip-Flop test complete.");
        $finish;
    end
endmodule
