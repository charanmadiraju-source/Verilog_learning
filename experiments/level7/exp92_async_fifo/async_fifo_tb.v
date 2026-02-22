`timescale 1ns/1ps
module async_fifo_tb;
    reg wr_clk=0,rd_clk=0,rst,wr_en,rd_en; reg [7:0] din; wire [7:0] dout; wire full,empty;
    always #4 wr_clk=~wr_clk;
    always #6 rd_clk=~rd_clk;
    async_fifo #(.DEPTH(8),.WIDTH(8)) uut(.wr_clk(wr_clk),.rd_clk(rd_clk),.rst(rst),
        .wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),.full(full),.empty(empty));
    integer errors=0;
    initial begin
        $dumpfile("async_fifo.vcd"); $dumpvars(0,async_fifo_tb);
        rst=1;wr_en=0;rd_en=0; #30; rst=0;
        // Write 3 values on wr_clk
        @(posedge wr_clk); #1; wr_en=1;din=8'hAA;
        @(posedge wr_clk); #1; din=8'hBB;
        @(posedge wr_clk); #1; din=8'hCC;
        @(posedge wr_clk); #1; wr_en=0;
        // Wait for sync (many cycles)
        repeat(10) @(posedge rd_clk); #1;
        // Check not empty
        if(empty)begin $display("FAIL should not be empty after writes");errors=errors+1;end
        // Read 3 values on rd_clk
        rd_en=1;
        @(posedge rd_clk);#1;
        @(posedge rd_clk);#1;
        @(posedge rd_clk);#1; rd_en=0;
        // Wait for sync
        repeat(15) @(posedge rd_clk); #1;
        if(!empty)begin $display("FAIL should be empty after reads");errors=errors+1;end
        if(errors==0) $display("PASS: Async FIFO test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
