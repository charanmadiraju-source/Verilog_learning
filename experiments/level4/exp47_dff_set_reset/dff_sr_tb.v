`timescale 1ns/1ps
module dff_sr_tb;
    reg clk=0,set,rst,d; wire q;
    always #5 clk=~clk;
    dff_sr uut(.clk(clk),.set(set),.rst(rst),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("dff_sr.vcd"); $dumpvars(0,dff_sr_tb);
        set=0;rst=1;d=0;#3; if(q!==0)begin $display("FAIL rst");errors=errors+1;end
        rst=0;
        set=1;#3; if(q!==1)begin $display("FAIL set");errors=errors+1;end
        set=0;
        rst=1;d=1;#3; if(q!==0)begin $display("FAIL rst priority");errors=errors+1;end
        rst=0;
        d=1; @(posedge clk);#1; if(q!==1)begin $display("FAIL clk load");errors=errors+1;end
        if(errors==0) $display("PASS: DFF Set/Reset test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
