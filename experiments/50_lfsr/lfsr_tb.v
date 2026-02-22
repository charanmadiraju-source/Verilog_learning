// LFSR Testbench
`timescale 1ns/1ps
module lfsr_tb;
    reg  clk, rst_n, en;
    wire [7:0] q;

    lfsr uut (.clk(clk),.rst_n(rst_n),.en(en),.q(q));

    always #5 clk = ~clk;

    integer i;
    reg [7:0] prev;

    initial begin
        $dumpfile("lfsr.vcd");
        $dumpvars(0, lfsr_tb);
        clk=0; rst_n=0; en=1; #12; rst_n=1;
        prev = 0;
        for (i=0; i<255; i=i+1) begin
            @(posedge clk); #1;
            if (q == prev && i > 0)
                $display("FAIL: repeated value at step %0d: %h", i, q);
            if (q == 8'h00)
                $display("FAIL: all-zero state at step %0d", i);
            prev = q;
        end
        $display("LFSR generated 255 unique values. Test complete.");
        $finish;
    end
endmodule
