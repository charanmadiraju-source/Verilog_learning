// 4-Bit Sync Down Counter Testbench
`timescale 1ns/1ps
module sync_down_counter_4bit_tb;
    reg  clk, rst_n, en;
    wire [3:0] q;

    sync_down_counter_4bit uut (.clk(clk),.rst_n(rst_n),.en(en),.q(q));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("sync_down_counter_4bit.vcd");
        $dumpvars(0, sync_down_counter_4bit_tb);
        clk=0; rst_n=0; en=1; #12; rst_n=1;
        for (i = 14; i >= 0; i = i - 1) begin
            @(posedge clk); #1;
            if (q !== i[3:0])
                $display("FAIL at step: q=%0d expected=%0d", q, i);
        end
        $display("Sync Down Counter test complete.");
        $finish;
    end
endmodule
