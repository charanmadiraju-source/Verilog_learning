`timescale 1ns/1ps
module dma_simple_tb;
    reg clk=0,rst,start; reg [7:0] src_base,dst_base,len;
    wire done,mem_wr_en; wire [7:0] mem_rd_addr,mem_wr_addr,count;
    always #5 clk=~clk;
    dma_simple uut(.clk(clk),.rst(rst),.start(start),.src_base(src_base),.dst_base(dst_base),.len(len),
        .done(done),.mem_wr_en(mem_wr_en),.mem_rd_addr(mem_rd_addr),.mem_wr_addr(mem_wr_addr),.count(count));
    integer errors=0;
    reg saw_done;
    initial begin
        $dumpfile("dma_simple.vcd"); $dumpvars(0,dma_simple_tb);
        rst=1; @(posedge clk);#1; rst=0;
        src_base=8'h10; dst_base=8'h40; len=8'd8; start=1; saw_done=0;
        @(posedge clk);#1; start=0;
        repeat(15) begin @(posedge clk);#1; if(done) saw_done=1; end
        if(!saw_done)begin $display("FAIL DMA done never seen");errors=errors+1;end
        if(errors==0) $display("PASS: DMA Controller test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
