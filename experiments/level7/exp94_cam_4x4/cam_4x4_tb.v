`timescale 1ns/1ps
module cam_4x4_tb;
    reg clk=0,wr_en; reg [1:0] wr_addr; reg [3:0] wr_data,search_data; wire match; wire [1:0] match_addr;
    always #5 clk=~clk;
    cam_4x4 uut(.clk(clk),.wr_en(wr_en),.wr_addr(wr_addr),.wr_data(wr_data),.search_data(search_data),.match(match),.match_addr(match_addr));
    integer errors=0;
    initial begin
        $dumpfile("cam_4x4.vcd"); $dumpvars(0,cam_4x4_tb);
        wr_en=0;search_data=0;
        wr_en=1;wr_addr=2'd1;wr_data=4'hA; @(posedge clk);#1;
        wr_addr=2'd3;wr_data=4'h5; @(posedge clk);#1; wr_en=0;
        search_data=4'hA; #5;
        if(match!==1||match_addr!==2'd1)begin $display("FAIL search A");errors=errors+1;end
        search_data=4'h5; #5;
        if(match!==1||match_addr!==2'd3)begin $display("FAIL search 5");errors=errors+1;end
        search_data=4'hF; #5;
        if(match!==0)begin $display("FAIL no match");errors=errors+1;end
        if(errors==0) $display("PASS: CAM 4x4 test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
