`timescale 1ns/1ps
module ram_dp_tb;
    reg clk=0,wr_en; reg [2:0] wr_addr,rd_addr; reg [7:0] wr_data; wire [7:0] rd_data;
    always #5 clk=~clk;
    ram_dp uut(.clk(clk),.wr_en(wr_en),.wr_addr(wr_addr),.wr_data(wr_data),.rd_addr(rd_addr),.rd_data(rd_data));
    integer errors=0;
    initial begin
        $dumpfile("ram_dp.vcd"); $dumpvars(0,ram_dp_tb);
        wr_en=1;wr_addr=3'd2;wr_data=8'hDE; @(posedge clk);#1;
        rd_addr=3'd2; #2; if(rd_data!==8'hDE)begin $display("FAIL dp read");errors=errors+1;end
        if(errors==0) $display("PASS: Dual-Port RAM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
