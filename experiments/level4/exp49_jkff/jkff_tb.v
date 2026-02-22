`timescale 1ns/1ps
module jkff_tb;
    reg clk=0,rst,j,k; wire q;
    always #5 clk=~clk;
    jkff uut(.clk(clk),.rst(rst),.j(j),.k(k),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("jkff.vcd"); $dumpvars(0,jkff_tb);
        rst=1;j=0;k=0; @(posedge clk);#1; rst=0;
        j=1;k=0; @(posedge clk);#1; if(q!==1)begin $display("FAIL set");errors=errors+1;end
        j=0;k=0; @(posedge clk);#1; if(q!==1)begin $display("FAIL hold");errors=errors+1;end
        j=0;k=1; @(posedge clk);#1; if(q!==0)begin $display("FAIL reset");errors=errors+1;end
        j=1;k=1; @(posedge clk);#1; if(q!==1)begin $display("FAIL toggle0->1");errors=errors+1;end
        j=1;k=1; @(posedge clk);#1; if(q!==0)begin $display("FAIL toggle1->0");errors=errors+1;end
        if(errors==0) $display("PASS: JK Flip-Flop test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
