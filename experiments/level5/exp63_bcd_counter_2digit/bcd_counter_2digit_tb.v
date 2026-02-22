`timescale 1ns/1ps
module bcd_counter_2digit_tb;
    reg clk=0,rst; wire [3:0] tens,ones;
    always #5 clk=~clk;
    bcd_counter_2digit uut(.clk(clk),.rst(rst),.tens(tens),.ones(ones));
    integer i,errors=0;
    initial begin
        $dumpfile("bcd_counter_2digit.vcd"); $dumpvars(0,bcd_counter_2digit_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Count to 19
        for(i=0;i<20;i=i+1) begin
            if(ones!==i%10||tens!==i/10) begin
                $display("FAIL i=%0d tens=%0d ones=%0d",i,tens,ones);errors=errors+1;end
            @(posedge clk);#1;
        end
        if(errors==0) $display("PASS: 2-digit BCD Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
