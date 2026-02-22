`timescale 1ns/1ps
module seq_det_1101_mealy_tb;
    reg clk=0,rst,in; wire detected;
    always #5 clk=~clk;
    seq_det_1101_mealy uut(.clk(clk),.rst(rst),.in(in),.detected(detected));
    integer errors=0;
    initial begin
        $dumpfile("seq_det_1101_mealy.vcd"); $dumpvars(0,seq_det_1101_mealy_tb);
        rst=1;in=0; @(posedge clk);#1; rst=0;
        // Drive 1,1,0 then check detected when in=1
        in=1; @(posedge clk);#1;
        in=1; @(posedge clk);#1;
        in=0; @(posedge clk);#1;
        in=1; #1; // don't clock yet - Mealy output visible combinatorially
        if(detected!==1)begin $display("FAIL no Mealy detect");errors=errors+1;end
        @(posedge clk);#1;
        if(errors==0) $display("PASS: 1101 Mealy Detector test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
