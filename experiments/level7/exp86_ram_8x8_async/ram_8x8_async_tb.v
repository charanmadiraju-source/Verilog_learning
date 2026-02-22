`timescale 1ns/1ps
module ram_8x8_async_tb;
    reg clk=0,we; reg [2:0] addr; reg [7:0] din; wire [7:0] dout;
    always #5 clk=~clk;
    ram_8x8_async uut(.clk(clk),.we(we),.addr(addr),.din(din),.dout(dout));
    integer errors=0;
    initial begin
        $dumpfile("ram_8x8_async.vcd"); $dumpvars(0,ram_8x8_async_tb);
        we=1;addr=3'd3;din=8'hAB; @(posedge clk);#1;
        we=0;addr=3'd3;#1; if(dout!==8'hAB)begin $display("FAIL read");errors=errors+1;end
        we=1;addr=3'd7;din=8'h55; @(posedge clk);#1;
        we=0;addr=3'd7;#1; if(dout!==8'h55)begin $display("FAIL read2");errors=errors+1;end
        if(errors==0) $display("PASS: 8x8 Async RAM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
