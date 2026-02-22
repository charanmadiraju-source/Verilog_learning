`timescale 1ns/1ps
module dsp_mac_tb;
    reg clk=0,rst,en; reg signed [7:0] a,b; wire signed [23:0] acc;
    always #5 clk=~clk;
    dsp_mac uut(.clk(clk),.rst(rst),.en(en),.a(a),.b(b),.acc(acc));
    integer errors=0;
    initial begin
        $dumpfile("dsp_mac.vcd"); $dumpvars(0,dsp_mac_tb);
        rst=1; @(posedge clk);#1; rst=0;
        en=1;
        a=8'sd3;b=8'sd4; @(posedge clk);#1;  // acc=12
        a=8'sd5;b=8'sd2; @(posedge clk);#1;  // acc=22
        a=-8'sd2;b=8'sd3;@(posedge clk);#1;  // acc=16
        en=0; @(posedge clk);#1;
        if(acc!==24'sd16)begin $display("FAIL acc=%0d exp=16",acc);errors=errors+1;end
        if(errors==0) $display("PASS: DSP MAC test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
