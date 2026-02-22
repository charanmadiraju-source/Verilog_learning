`timescale 1ns/1ps
module sr_latch_nand_tb;
    reg s_n, r_n; wire q, q_n;
    sr_latch_nand uut(.s_n(s_n),.r_n(r_n),.q(q),.q_n(q_n));
    integer errors=0;
    initial begin
        $dumpfile("sr_latch_nand.vcd"); $dumpvars(0,sr_latch_nand_tb);
        s_n=1;r_n=1;#20;
        // Set
        s_n=0;r_n=1;#20; if(q!==1)begin $display("FAIL Set q");errors=errors+1;end
        s_n=1;r_n=1;#20; if(q!==1)begin $display("FAIL Hold after set");errors=errors+1;end
        // Reset
        s_n=1;r_n=0;#20; if(q!==0)begin $display("FAIL Reset q");errors=errors+1;end
        s_n=1;r_n=1;#20; if(q!==0)begin $display("FAIL Hold after reset");errors=errors+1;end
        if(errors==0) $display("PASS: SR Latch test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
