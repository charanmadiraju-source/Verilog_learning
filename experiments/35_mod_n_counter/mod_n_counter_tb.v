// Mod-N Counter Testbench (N=6 example)
`timescale 1ns/1ps
module mod_n_counter_tb;
    parameter N = 6;
    reg  clk, rst_n;
    wire [$clog2(N)-1:0] q;

    mod_n_counter #(.N(N)) uut (.clk(clk),.rst_n(rst_n),.q(q));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("mod_n_counter.vcd");
        $dumpvars(0, mod_n_counter_tb);
        clk=0; rst_n=0; #12; rst_n=1;
        for (i = 0; i < N*2; i = i + 1) begin
            @(posedge clk); #1;
            if (q !== (i+1) % N)
                $display("FAIL step %0d: q=%0d expected=%0d", i, q, (i+1)%N);
        end
        $display("Mod-%0d Counter test complete.", N);
        $finish;
    end
endmodule
