`timescale 1ns/1ps
module dff_tb;
    reg clk=0, d; wire q;
    always #5 clk=~clk;
    dff uut(.clk(clk),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("dff.vcd"); $dumpvars(0,dff_tb);
        d=0; @(posedge clk); #1; if(q!==0)begin $display("FAIL d=0");errors=errors+1;end
        d=1; @(posedge clk); #1; if(q!==1)begin $display("FAIL d=1");errors=errors+1;end
        d=0; @(posedge clk); #1; if(q!==0)begin $display("FAIL d=0 again");errors=errors+1;end
        if(errors==0) $display("PASS: D Flip-Flop test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
