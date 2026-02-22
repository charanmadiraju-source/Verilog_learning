// Universal Shift Register Testbench
`timescale 1ns/1ps
module universal_shift_register_tb;
    reg  clk, rst_n, si_right, si_left;
    reg  [1:0] mode;
    reg  [3:0] pi;
    wire [3:0] po;

    universal_shift_register uut (
        .clk(clk),.rst_n(rst_n),.mode(mode),
        .si_right(si_right),.si_left(si_left),.pi(pi),.po(po)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("universal_shift_register.vcd");
        $dumpvars(0, universal_shift_register_tb);
        clk=0; rst_n=0; mode=2'b00; pi=4'b0; si_right=0; si_left=0; #12; rst_n=1;
        // Parallel load
        mode=2'b11; pi=4'b1010; @(posedge clk); #1;
        if (po!==4'b1010) $display("FAIL: load");
        // Shift right
        mode=2'b01; si_right=1; @(posedge clk); #1;
        if (po!==4'b1101) $display("FAIL: shift-right");
        // Shift left
        mode=2'b10; si_left=0; @(posedge clk); #1;
        if (po!==4'b1010) $display("FAIL: shift-left");
        // Hold
        mode=2'b00; @(posedge clk); #1;
        if (po!==4'b1010) $display("FAIL: hold");
        $display("Universal Shift Register test complete.");
        $finish;
    end
endmodule
