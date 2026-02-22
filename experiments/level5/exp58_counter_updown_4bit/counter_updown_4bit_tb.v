`timescale 1ns/1ps
module counter_updown_4bit_tb;
    reg clk=0,rst,up; wire [3:0] count;
    always #5 clk=~clk;
    counter_updown_4bit uut(.clk(clk),.rst(rst),.up(up),.count(count));
    integer errors=0;
    initial begin
        $dumpfile("counter_updown_4bit.vcd"); $dumpvars(0,counter_updown_4bit_tb);
        rst=1;up=1; @(posedge clk);#1; rst=0;
        @(posedge clk);#1; if(count!==4'd1)begin $display("FAIL up1");errors=errors+1;end
        @(posedge clk);#1; if(count!==4'd2)begin $display("FAIL up2");errors=errors+1;end
        up=0;
        @(posedge clk);#1; if(count!==4'd1)begin $display("FAIL dn1");errors=errors+1;end
        @(posedge clk);#1; if(count!==4'd0)begin $display("FAIL dn0");errors=errors+1;end
        if(errors==0) $display("PASS: Up/Down Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
