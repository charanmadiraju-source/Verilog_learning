// Clock Divider Testbench
`timescale 1ns/1ps
module clock_divider_tb;
    reg  clk, rst_n;
    wire clk_div, pulse;

    clock_divider #(.DIV_FACTOR(4)) uut (.clk(clk),.rst_n(rst_n),.clk_div(clk_div),.pulse(pulse));

    always #5 clk = ~clk;

    integer toggles = 0;
    always @(posedge clk_div) toggles = toggles + 1;

    initial begin
        $dumpfile("clock_divider.vcd");
        $dumpvars(0, clock_divider_tb);
        clk=0; rst_n=0; #12; rst_n=1;
        // Run for 32 system clocks -> expect 4 rising edges on clk_div
        repeat(32) @(posedge clk);
        #1;
        if (toggles < 3 || toggles > 5)
            $display("FAIL: expected ~4 clk_div rising edges, got %0d", toggles);
        $display("Clock divider toggles=%0d (expected 4 in 32 cycles)", toggles);
        $display("Clock Divider test complete.");
        $finish;
    end
endmodule
