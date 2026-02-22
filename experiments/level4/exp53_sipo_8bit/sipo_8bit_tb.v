`timescale 1ns/1ps
module sipo_8bit_tb;
    reg clk=0,rst,sin; wire [7:0] parallel_out;
    always #5 clk=~clk;
    sipo_8bit uut(.clk(clk),.rst(rst),.sin(sin),.parallel_out(parallel_out));
    integer i, errors=0;
    reg [7:0] data = 8'b11001010;
    initial begin
        $dumpfile("sipo_8bit.vcd"); $dumpvars(0,sipo_8bit_tb);
        rst=1;sin=0; @(posedge clk);#1; rst=0;
        for(i=7;i>=0;i=i-1) begin
            sin=data[i]; @(posedge clk);#1;
        end
        if(parallel_out!==data) begin $display("FAIL got %b exp %b",parallel_out,data);errors=errors+1;end
        if(errors==0) $display("PASS: SIPO 8-bit test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
