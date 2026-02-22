// Johnson Counter Testbench
`timescale 1ns/1ps
module johnson_counter_tb;
    reg  clk, rst_n;
    wire [3:0] q;

    johnson_counter uut (.clk(clk),.rst_n(rst_n),.q(q));

    always #5 clk = ~clk;

    // 4-bit Johnson sequence: 8 unique states
    reg [3:0] expected [0:7];
    integer i;

    initial begin
        expected[0]=4'b1000; expected[1]=4'b1100; expected[2]=4'b1110; expected[3]=4'b1111;
        expected[4]=4'b0111; expected[5]=4'b0011; expected[6]=4'b0001; expected[7]=4'b0000;

        $dumpfile("johnson_counter.vcd");
        $dumpvars(0, johnson_counter_tb);
        clk=0; rst_n=0; #12; rst_n=1;
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            if (q !== expected[i])
                $display("FAIL step %0d: q=%b exp=%b", i, q, expected[i]);
        end
        $display("Johnson Counter test complete.");
        $finish;
    end
endmodule
