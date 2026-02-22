// Up-Down Counter Testbench
`timescale 1ns/1ps
module up_down_counter_4bit_tb;
    reg  clk, rst_n, en, up_down;
    wire [3:0] q;

    up_down_counter_4bit uut (.clk(clk),.rst_n(rst_n),.en(en),.up_down(up_down),.q(q));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("up_down_counter_4bit.vcd");
        $dumpvars(0, up_down_counter_4bit_tb);
        clk=0; rst_n=0; en=1; up_down=1; #12; rst_n=1;
        // Count up 5 times
        repeat(5) @(posedge clk); #1;
        if (q!==5) $display("FAIL up: q=%0d", q);
        // Count down 3 times
        up_down=0; repeat(3) @(posedge clk); #1;
        if (q!==2) $display("FAIL down: q=%0d", q);
        $display("Up-Down Counter test complete.");
        $finish;
    end
endmodule
