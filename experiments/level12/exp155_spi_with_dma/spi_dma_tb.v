`timescale 1ns/1ps
module spi_dma_tb;
    reg clk=0,rst,dma_start; reg [31:0] dma_mem; wire [31:0] rx_mem; wire done;
    always #5 clk=~clk;
    spi_dma #(.N(4)) uut(.clk(clk),.rst(rst),.dma_start(dma_start),.dma_mem(dma_mem),.rx_mem(rx_mem),.done(done));
    integer errors=0; reg saw_done;
    initial begin
        $dumpfile("spi_dma.vcd"); $dumpvars(0,spi_dma_tb);
        rst=1;dma_start=0;dma_mem={8'hDD,8'hCC,8'hBB,8'hAA};
        @(posedge clk);#1;rst=0;dma_start=1;@(posedge clk);#1;dma_start=0;
        saw_done=0;repeat(100)begin @(posedge clk);#1;if(done)saw_done=1;end
        if(!saw_done)begin $display("FAIL no done");errors=errors+1;end
        if(errors==0)$display("PASS: SPI DMA test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
