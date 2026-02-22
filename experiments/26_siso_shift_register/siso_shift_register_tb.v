// SISO Shift Register Testbench
`timescale 1ns/1ps
module siso_shift_register_tb;
    reg  clk, rst_n, si;
    wire so;

    siso_shift_register uut (.clk(clk),.rst_n(rst_n),.si(si),.so(so));

    always #5 clk = ~clk;

    integer i;
    reg [3:0] data;

    initial begin
        $dumpfile("siso_shift_register.vcd");
        $dumpvars(0, siso_shift_register_tb);
        clk=0; rst_n=0; si=0; #12; rst_n=1;
        data = 4'b1011;
        // Shift in MSB first
        for (i = 3; i >= 0; i = i - 1) begin
            si = data[i]; @(posedge clk); #1;
        end
        // After 4 clocks, so should reflect the first shifted-in bit
        $display("SISO output so=%b (input was 1011, expect 1)", so);
        $display("SISO Shift Register test complete.");
        $finish;
    end
endmodule
