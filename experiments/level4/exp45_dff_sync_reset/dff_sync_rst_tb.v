`timescale 1ns/1ps
module dff_sync_rst_tb;
    reg clk=0,rst,d; wire q;
    always #5 clk=~clk;
    dff_sync_rst uut(.clk(clk),.rst(rst),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("dff_sync_rst.vcd"); $dumpvars(0,dff_sync_rst_tb);
        rst=1;d=0; @(posedge clk);#1; if(q!==0)begin $display("FAIL sync reset");errors=errors+1;end
        rst=0;d=1; @(posedge clk);#1; if(q!==1)begin $display("FAIL load");errors=errors+1;end
        rst=1;d=1; #3; if(q!==1)begin $display("FAIL sync-reset not immediate");errors=errors+1;end
        @(posedge clk);#1; if(q!==0)begin $display("FAIL sync reset on edge");errors=errors+1;end
        if(errors==0) $display("PASS: DFF Sync Reset test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
