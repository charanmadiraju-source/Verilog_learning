// PIPO Shift Register Testbench
`timescale 1ns/1ps
module pipo_shift_register_tb;
    reg  clk, rst_n, load;
    reg  [3:0] pi;
    wire [3:0] po;

    pipo_shift_register uut (.clk(clk),.rst_n(rst_n),.load(load),.pi(pi),.po(po));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("pipo_shift_register.vcd");
        $dumpvars(0, pipo_shift_register_tb);
        clk=0; rst_n=0; load=0; pi=4'h0; #12; rst_n=1;
        pi=4'hA; load=1; @(posedge clk); #1;
        if (po!==4'hA) $display("FAIL: load A");
        pi=4'hF; load=0; @(posedge clk); #1;
        if (po!==4'hA) $display("FAIL: hold");
        $display("PIPO Shift Register test complete.");
        $finish;
    end
endmodule
