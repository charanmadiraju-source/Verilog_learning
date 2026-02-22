`timescale 1ns/1ps
module counter_down_4bit_tb;
    reg clk=0,rst; wire [3:0] count;
    always #5 clk=~clk;
    counter_down_4bit uut(.clk(clk),.rst(rst),.count(count));
    integer i,errors=0;
    initial begin
        $dumpfile("counter_down_4bit.vcd"); $dumpvars(0,counter_down_4bit_tb);
        rst=1; @(posedge clk);#1; rst=0;
        for(i=15;i>=0;i=i-1) begin
            if(count!==i)begin $display("FAIL count=%0d exp=%0d",count,i);errors=errors+1;end
            @(posedge clk);#1;
        end
        if(count!==4'd15)begin $display("FAIL wrap");errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit Down Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
