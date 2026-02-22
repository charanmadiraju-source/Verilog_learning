// 4-Bit Register Testbench
`timescale 1ns/1ps
module register_4bit_tb;
    reg  clk, rst_n, load;
    reg  [3:0] d;
    wire [3:0] q;

    register_4bit uut (.clk(clk),.rst_n(rst_n),.load(load),.d(d),.q(q));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_4bit.vcd");
        $dumpvars(0, register_4bit_tb);
        clk=0; rst_n=0; load=0; d=4'hA; #12; rst_n=1;
        if (q!==4'h0) $display("FAIL: reset");
        load=1; d=4'b1010; @(posedge clk); #1;
        if (q!==4'b1010) $display("FAIL: load");
        load=0; d=4'b1111; @(posedge clk); #1;
        if (q!==4'b1010) $display("FAIL: hold");
        $display("4-Bit Register test complete.");
        $finish;
    end
endmodule
