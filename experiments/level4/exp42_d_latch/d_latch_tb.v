`timescale 1ns/1ps
module d_latch_tb;
    reg d, en; wire q;
    d_latch uut(.d(d),.en(en),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("d_latch.vcd"); $dumpvars(0,d_latch_tb);
        en=1;d=0;#10; if(q!==0)begin $display("FAIL transparent 0");errors=errors+1;end
        d=1;#10;       if(q!==1)begin $display("FAIL transparent 1");errors=errors+1;end
        en=0;d=0;#10;  if(q!==1)begin $display("FAIL hold");errors=errors+1;end
        en=1;d=0;#10;  if(q!==0)begin $display("FAIL re-enable");errors=errors+1;end
        if(errors==0) $display("PASS: D Latch test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
