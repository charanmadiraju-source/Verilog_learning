// BCD Counter Testbench
`timescale 1ns/1ps
module bcd_counter_tb;
    reg  clk, rst_n;
    wire [3:0] q;
    wire carry;

    bcd_counter uut (.clk(clk),.rst_n(rst_n),.q(q),.carry(carry));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("bcd_counter.vcd");
        $dumpvars(0, bcd_counter_tb);
        clk=0; rst_n=0; #12; rst_n=1;
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk); #1;
            if (q > 9) $display("FAIL: q=%0d out of BCD range", q);
            $display("q=%0d carry=%b", q, carry);
        end
        $display("BCD Counter test complete.");
        $finish;
    end
endmodule
