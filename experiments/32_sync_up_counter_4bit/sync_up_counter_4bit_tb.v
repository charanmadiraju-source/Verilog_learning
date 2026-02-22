// 4-Bit Sync Up Counter Testbench
`timescale 1ns/1ps
module sync_up_counter_4bit_tb;
    reg  clk, rst_n, en;
    wire [3:0] q;

    sync_up_counter_4bit uut (.clk(clk),.rst_n(rst_n),.en(en),.q(q));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("sync_up_counter_4bit.vcd");
        $dumpvars(0, sync_up_counter_4bit_tb);
        clk=0; rst_n=0; en=1; #12; rst_n=1;
        // Test all 16 expected counts (counter wraps 15→0)
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clk); #1;
            if (q !== i[3:0] % 16)
                $display("FAIL at count %0d: q=%b", i, q);
        end
        $display("Sync Up Counter test complete.");
        $finish;
    end
endmodule
