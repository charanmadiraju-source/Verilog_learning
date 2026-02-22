// PISO Shift Register Testbench
`timescale 1ns/1ps
module piso_shift_register_tb;
    reg  clk, rst_n, load;
    reg  [3:0] pi;
    wire so;

    piso_shift_register uut (.clk(clk),.rst_n(rst_n),.load(load),.pi(pi),.so(so));

    always #5 clk = ~clk;

    integer i;
    reg [3:0] capture;

    initial begin
        $dumpfile("piso_shift_register.vcd");
        $dumpvars(0, piso_shift_register_tb);
        clk=0; rst_n=0; load=0; pi=4'b0; #12; rst_n=1;
        // Load 4'b1101
        pi=4'b1101; load=1; @(posedge clk); #1; load=0;
        // Shift out 4 bits
        for (i = 3; i >= 0; i = i - 1) begin
            capture[i] = so; @(posedge clk); #1;
        end
        if (capture !== 4'b1101) $display("FAIL: capture=%b expected 1101", capture);
        $display("PISO Shift Register test complete.");
        $finish;
    end
endmodule
