// 2-to-1 MUX Testbench
`timescale 1ns/1ps
module mux_2to1_tb;
    reg  a, b, sel;
    wire y;

    mux_2to1 uut (.a(a), .b(b), .sel(sel), .y(y));

    initial begin
        $dumpfile("mux_2to1.vcd");
        $dumpvars(0, mux_2to1_tb);
        a=0; b=1; sel=0; #10; if(y!==0) $display("FAIL sel=0");
        a=0; b=1; sel=1; #10; if(y!==1) $display("FAIL sel=1");
        a=1; b=0; sel=0; #10; if(y!==1) $display("FAIL sel=0 b");
        a=1; b=0; sel=1; #10; if(y!==0) $display("FAIL sel=1 b");
        $display("2-to-1 MUX test complete.");
        $finish;
    end
endmodule
