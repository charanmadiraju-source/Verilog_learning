`timescale 1ns/1ps
module dff_async_rst_tb;
    reg clk=0,rst,d; wire q;
    always #5 clk=~clk;
    dff_async_rst uut(.clk(clk),.rst(rst),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("dff_async_rst.vcd"); $dumpvars(0,dff_async_rst_tb);
        rst=1;d=0;#12; rst=0;
        d=1; @(posedge clk);#1; if(q!==1)begin $display("FAIL load 1");errors=errors+1;end
        rst=1; #3; if(q!==0)begin $display("FAIL async reset");errors=errors+1;end
        rst=0;
        if(errors==0) $display("PASS: DFF Async Reset test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
