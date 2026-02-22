`timescale 1ns/1ps
module tff_tb;
    reg clk=0,rst,t; wire q;
    always #5 clk=~clk;
    tff uut(.clk(clk),.rst(rst),.t(t),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("tff.vcd"); $dumpvars(0,tff_tb);
        rst=1;t=0; @(posedge clk);#1; rst=0;
        if(q!==0)begin $display("FAIL reset");errors=errors+1;end
        t=1; @(posedge clk);#1; if(q!==1)begin $display("FAIL toggle0->1");errors=errors+1;end
        @(posedge clk);#1;       if(q!==0)begin $display("FAIL toggle1->0");errors=errors+1;end
        t=0; @(posedge clk);#1;  if(q!==0)begin $display("FAIL hold");errors=errors+1;end
        if(errors==0) $display("PASS: T Flip-Flop test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
