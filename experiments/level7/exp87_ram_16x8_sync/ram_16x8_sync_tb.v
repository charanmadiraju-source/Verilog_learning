`timescale 1ns/1ps
module ram_16x8_sync_tb;
    reg clk=0,we; reg [3:0] addr; reg [7:0] din; wire [7:0] dout;
    always #5 clk=~clk;
    ram_16x8_sync uut(.clk(clk),.we(we),.addr(addr),.din(din),.dout(dout));
    integer errors=0;
    initial begin
        $dumpfile("ram_16x8_sync.vcd"); $dumpvars(0,ram_16x8_sync_tb);
        we=1;addr=4'd5;din=8'hC7; @(posedge clk);#1;
        we=0;addr=4'd5; @(posedge clk);#1;
        if(dout!==8'hC7)begin $display("FAIL sync read");errors=errors+1;end
        if(errors==0) $display("PASS: 16x8 Sync RAM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
