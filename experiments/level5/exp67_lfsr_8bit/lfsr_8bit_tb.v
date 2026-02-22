`timescale 1ns/1ps
module lfsr_8bit_tb;
    reg clk=0,rst; wire [7:0] q;
    always #5 clk=~clk;
    lfsr_8bit uut(.clk(clk),.rst(rst),.q(q));
    integer i,errors=0;
    initial begin
        $dumpfile("lfsr_8bit.vcd"); $dumpvars(0,lfsr_8bit_tb);
        rst=1; @(posedge clk);#1; rst=0;
        for(i=0;i<255;i=i+1) begin
            if(q===8'b0)begin $display("FAIL zero state at step %0d",i);errors=errors+1;end
            @(posedge clk);#1;
        end
        if(q!==8'b00000001)begin $display("FAIL maxlength: q=%b",q);errors=errors+1;end
        if(errors==0) $display("PASS: 8-bit LFSR test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
