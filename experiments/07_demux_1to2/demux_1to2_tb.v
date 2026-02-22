// 1-to-2 DEMUX Testbench
`timescale 1ns/1ps
module demux_1to2_tb;
    reg  in, sel;
    wire y0, y1;

    demux_1to2 uut (.in(in),.sel(sel),.y0(y0),.y1(y1));

    initial begin
        $dumpfile("demux_1to2.vcd");
        $dumpvars(0, demux_1to2_tb);
        in=1; sel=0; #10; if(y0!==1||y1!==0) $display("FAIL in=1 sel=0");
        in=1; sel=1; #10; if(y0!==0||y1!==1) $display("FAIL in=1 sel=1");
        in=0; sel=0; #10; if(y0!==0||y1!==0) $display("FAIL in=0 sel=0");
        in=0; sel=1; #10; if(y0!==0||y1!==0) $display("FAIL in=0 sel=1");
        $display("1-to-2 DEMUX test complete.");
        $finish;
    end
endmodule
