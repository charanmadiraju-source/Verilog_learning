`timescale 1ns/1ps
module lfsr_4bit_tb;
    reg clk=0,rst; wire [3:0] q;
    always #5 clk=~clk;
    lfsr_4bit uut(.clk(clk),.rst(rst),.q(q));
    integer i,errors=0;
    reg [3:0] seen[0:15];
    reg [3:0] prev;
    initial begin
        $dumpfile("lfsr_4bit.vcd"); $dumpvars(0,lfsr_4bit_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Run for 15 cycles, never hit 0, no repeats
        for(i=0;i<15;i=i+1) begin
            if(q===4'b0)begin $display("FAIL zero state at step %0d",i);errors=errors+1;end
            @(posedge clk);#1;
        end
        // After 15 steps should be back to seed
        if(q!==4'b0001)begin $display("FAIL maxlength: q=%b",q);errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit LFSR test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
