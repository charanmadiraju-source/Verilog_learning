`timescale 1ns/1ps
module seq_det_101_moore_tb;
    reg clk=0,rst,in; wire detected;
    always #5 clk=~clk;
    seq_det_101_moore uut(.clk(clk),.rst(rst),.in(in),.detected(detected));
    integer errors=0;
    task send; input b; begin in=b; @(posedge clk);#1; end endtask
    initial begin
        $dumpfile("seq_det_101_moore.vcd"); $dumpvars(0,seq_det_101_moore_tb);
        rst=1;in=0; @(posedge clk);#1; rst=0;
        // Send 1,0,1 -> detect
        send(1); send(0);
        send(1); if(detected!==1)begin $display("FAIL no detect");errors=errors+1;end
        // Overlapping: send 0,1 -> detect again
        send(0);
        send(1); if(detected!==1)begin $display("FAIL overlap detect");errors=errors+1;end
        if(errors==0) $display("PASS: 101 Sequence Detector test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
