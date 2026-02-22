`timescale 1ns/1ps
module counter_8bit_tc_tb;
    reg clk=0,rst; wire [7:0] count; wire tc;
    always #5 clk=~clk;
    counter_8bit_tc uut(.clk(clk),.rst(rst),.count(count),.tc(tc));
    integer errors=0;
    initial begin
        $dumpfile("counter_8bit_tc.vcd"); $dumpvars(0,counter_8bit_tc_tb);
        rst=1; @(posedge clk);#1; rst=0;
        if(count!==0||tc!==0)begin $display("FAIL init");errors=errors+1;end
        // Fast-forward to 254
        repeat(254) @(posedge clk); #1;
        if(count!==8'd254)begin $display("FAIL count=254");errors=errors+1;end
        @(posedge clk);#1;
        if(count!==8'd255||tc!==1)begin $display("FAIL tc");errors=errors+1;end
        @(posedge clk);#1;
        if(count!==8'd0)begin $display("FAIL wrap");errors=errors+1;end
        if(errors==0) $display("PASS: 8-bit Counter TC test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
