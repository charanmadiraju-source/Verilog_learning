// SIPO Shift Register Testbench
`timescale 1ns/1ps
module sipo_shift_register_tb;
    reg  clk, rst_n, si;
    wire [3:0] po;

    sipo_shift_register uut (.clk(clk),.rst_n(rst_n),.si(si),.po(po));

    always #5 clk = ~clk;

    integer i;
    reg [3:0] data;

    initial begin
        $dumpfile("sipo_shift_register.vcd");
        $dumpvars(0, sipo_shift_register_tb);
        clk=0; rst_n=0; si=0; #12; rst_n=1;
        data = 4'b1011;
        for (i = 3; i >= 0; i = i - 1) begin
            si = data[i]; @(posedge clk); #1;
        end
        if (po !== 4'b1011) $display("FAIL: po=%b expected 1011", po);
        $display("SIPO Shift Register test complete.");
        $finish;
    end
endmodule
