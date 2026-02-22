// Pipelined Multiplier Testbench
`timescale 1ns/1ps
module pipelined_multiplier_tb;
    reg        clk, rst_n;
    reg  [7:0] a, b;
    wire [15:0] product;

    pipelined_multiplier #(.WIDTH(8)) uut (.clk(clk),.rst_n(rst_n),.a(a),.b(b),.product(product));

    always #5 clk = ~clk;

    // Pipeline latency = 2 cycles
    reg [7:0] a_pipe [0:1], b_pipe [0:1];
    integer i;

    initial begin
        $dumpfile("pipelined_multiplier.vcd");
        $dumpvars(0, pipelined_multiplier_tb);
        clk=0; rst_n=0; a=0; b=0; #12; rst_n=1;
        // Feed inputs and check output 2 cycles later
        for (i = 0; i < 10; i = i + 1) begin
            a = $random % 256;
            b = $random % 256;
            a_pipe[1] = a_pipe[0]; b_pipe[1] = b_pipe[0];
            a_pipe[0] = a;         b_pipe[0] = b;
            @(posedge clk); #1;
            if (i >= 2 && product !== (a_pipe[1] * b_pipe[1]))
                $display("FAIL: %0d * %0d = %0d (got %0d)",
                          a_pipe[1], b_pipe[1], a_pipe[1]*b_pipe[1], product);
        end
        $display("Pipelined Multiplier test complete.");
        $finish;
    end
endmodule
