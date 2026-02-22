// JK Flip-Flop Testbench
`timescale 1ns/1ps
module jkff_tb;
    reg  clk, rst_n, j, k;
    wire q;

    jkff uut (.clk(clk),.rst_n(rst_n),.j(j),.k(k),.q(q));

    task apply;
        input ji, ki;
        begin
            j=ji; k=ki; @(posedge clk); #1;
        end
    endtask

    always #5 clk = ~clk;

    initial begin
        $dumpfile("jkff.vcd");
        $dumpvars(0, jkff_tb);
        clk=0; rst_n=0; j=0; k=0; #12; rst_n=1;
        apply(1,0); if(q!==1) $display("FAIL: set");
        apply(0,0); if(q!==1) $display("FAIL: hold");
        apply(0,1); if(q!==0) $display("FAIL: reset");
        apply(1,1); if(q!==1) $display("FAIL: toggle to 1");
        apply(1,1); if(q!==0) $display("FAIL: toggle to 0");
        $display("JK Flip-Flop test complete.");
        $finish;
    end
endmodule
