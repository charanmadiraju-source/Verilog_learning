`timescale 1ns/1ps
module freq_divider_tb;
    reg clk=0,rst; wire clk_div2,clk_div4,clk_div8,clk_div16;
    always #5 clk=~clk;
    freq_divider uut(.clk(clk),.rst(rst),.clk_div2(clk_div2),.clk_div4(clk_div4),
                     .clk_div8(clk_div8),.clk_div16(clk_div16));
    integer errors=0;
    initial begin
        $dumpfile("freq_divider.vcd"); $dumpvars(0,freq_divider_tb);
        rst=1; #3; rst=0;
        // After 8 rising edges, cnt=8, clk_div16(cnt[3])=1
        repeat(8) @(posedge clk); #1;
        if(clk_div16!==1)begin $display("FAIL div16 after 8 edges, val=%b",clk_div16);errors=errors+1;end
        // After 4 more (12 total), cnt=12, clk_div8(cnt[2])=1
        repeat(4) @(posedge clk); #1;
        if(clk_div8!==1)begin $display("FAIL div8 after 12 edges, val=%b",clk_div8);errors=errors+1;end
        if(errors==0) $display("PASS: Frequency Divider test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
