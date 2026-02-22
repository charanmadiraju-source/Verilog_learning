// Ring Counter Testbench
`timescale 1ns/1ps
module ring_counter_tb;
    reg  clk, rst_n;
    wire [3:0] q;

    ring_counter uut (.clk(clk),.rst_n(rst_n),.q(q));

    always #5 clk = ~clk;

    reg [3:0] expected [0:3];
    integer i;

    initial begin
        expected[0]=4'b0010; expected[1]=4'b0100;
        expected[2]=4'b1000; expected[3]=4'b0001;

        $dumpfile("ring_counter.vcd");
        $dumpvars(0, ring_counter_tb);
        clk=0; rst_n=0; #12; rst_n=1;
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            if (q !== expected[i % 4])
                $display("FAIL step %0d: q=%b exp=%b", i, q, expected[i%4]);
        end
        $display("Ring Counter test complete.");
        $finish;
    end
endmodule
