`timescale 1ns/1ps
module bcd_counter_tb;
    reg clk=0,rst; wire [3:0] count; wire carry;
    always #5 clk=~clk;
    bcd_counter uut(.clk(clk),.rst(rst),.count(count),.carry(carry));
    integer i,errors=0;
    initial begin
        $dumpfile("bcd_counter.vcd"); $dumpvars(0,bcd_counter_tb);
        rst=1; @(posedge clk);#1; rst=0;
        for(i=0;i<10;i=i+1) begin
            if(count!==i)begin $display("FAIL count=%0d exp=%0d",count,i);errors=errors+1;end
            if(i==9&&carry!==1)begin $display("FAIL carry");errors=errors+1;end
            @(posedge clk);#1;
        end
        if(count!==0)begin $display("FAIL wrap to 0");errors=errors+1;end
        if(errors==0) $display("PASS: BCD Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
