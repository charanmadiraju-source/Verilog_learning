// 8-to-1 MUX Testbench
`timescale 1ns/1ps
module mux_8to1_tb;
    reg  [7:0] in;
    reg  [2:0] sel;
    wire y;

    mux_8to1 uut (.in(in),.sel(sel),.y(y));

    integer i;
    initial begin
        $dumpfile("mux_8to1.vcd");
        $dumpvars(0, mux_8to1_tb);
        in = 8'b10110100;
        for (i = 0; i < 8; i = i + 1) begin
            sel = i[2:0]; #10;
            if (y !== in[i]) $display("FAIL sel=%0d", i);
        end
        $display("8-to-1 MUX test complete.");
        $finish;
    end
endmodule
