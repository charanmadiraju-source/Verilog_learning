`timescale 1ns/1ps
module cache_direct_tb;
    reg clk=0,rst,wr_en; reg [3:0] addr; reg [7:0] din; wire [7:0] dout; wire hit;
    always #5 clk=~clk;
    cache_direct uut(.clk(clk),.rst(rst),.wr_en(wr_en),.addr(addr),.din(din),.dout(dout),.hit(hit));
    integer errors=0;
    initial begin
        $dumpfile("cache_direct.vcd"); $dumpvars(0,cache_direct_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Write to addr 4'b0110 (tag=01, index=10)
        wr_en=1;addr=4'b0110;din=8'hAB; @(posedge clk);#1; wr_en=0;
        // Read hit
        addr=4'b0110; #2; if(hit!==1||dout!==8'hAB)begin $display("FAIL hit");errors=errors+1;end
        // Read miss (different tag, same index)
        addr=4'b1010; #2; if(hit!==0)begin $display("FAIL miss");errors=errors+1;end
        if(errors==0) $display("PASS: Direct-Mapped Cache test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
