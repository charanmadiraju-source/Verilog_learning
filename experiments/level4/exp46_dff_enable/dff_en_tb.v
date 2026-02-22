`timescale 1ns/1ps
module dff_en_tb;
    reg clk=0,rst,en,d; wire q;
    always #5 clk=~clk;
    dff_en uut(.clk(clk),.rst(rst),.en(en),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("dff_en.vcd"); $dumpvars(0,dff_en_tb);
        rst=1;en=0;d=0; @(posedge clk);#1; rst=0;
        en=1;d=1; @(posedge clk);#1; if(q!==1)begin $display("FAIL en=1");errors=errors+1;end
        en=0;d=0; @(posedge clk);#1; if(q!==1)begin $display("FAIL hold");errors=errors+1;end
        en=1;d=0; @(posedge clk);#1; if(q!==0)begin $display("FAIL update");errors=errors+1;end
        if(errors==0) $display("PASS: DFF Enable test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
