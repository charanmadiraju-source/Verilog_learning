// 4-Bit Ripple Counter Testbench
`timescale 1ns/1ps
module ripple_counter_4bit_tb;
    reg  clk, rst_n;
    wire [3:0] q;

    ripple_counter_4bit uut (.clk(clk),.rst_n(rst_n),.q(q));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("ripple_counter_4bit.vcd");
        $dumpvars(0, ripple_counter_4bit_tb);
        clk=0; rst_n=0; #12; rst_n=1;
        for (i = 1; i <= 16; i = i + 1) begin
            @(negedge clk); #1;
            $display("count = %0d  q = %b", i, q);
        end
        $display("Ripple Counter test complete.");
        $finish;
    end
endmodule
