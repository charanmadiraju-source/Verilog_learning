`timescale 1ns/1ps
module prog_freq_divider_tb;
    reg clk=0,rst; reg [3:0] divisor; wire clk_out;
    always #5 clk=~clk;
    prog_freq_divider uut(.clk(clk),.rst(rst),.divisor(divisor),.clk_out(clk_out));
    integer errors=0;
    initial begin
        $dumpfile("prog_freq_divider.vcd"); $dumpvars(0,prog_freq_divider_tb);
        rst=1;divisor=4'd4; @(posedge clk);#1; rst=0;
        // Just run for a while without hanging or going X
        repeat(20) @(posedge clk); #1;
        if(clk_out===1'bx) begin $display("FAIL: output is X"); errors=errors+1; end
        if(errors==0) $display("PASS: Programmable Frequency Divider test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
