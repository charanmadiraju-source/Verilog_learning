`timescale 1ns/1ps
module spi_master_tb;
    reg clk=0,rst,start,miso; reg [7:0] mosi_data;
    wire mosi,sclk,cs_n,done; wire [7:0] rx_data;
    always #5 clk=~clk;
    spi_master uut(.clk(clk),.rst(rst),.start(start),.miso(miso),.mosi_data(mosi_data),
                   .mosi(mosi),.sclk(sclk),.cs_n(cs_n),.done(done),.rx_data(rx_data));
    integer errors=0;
    reg saw_done;
    initial begin
        $dumpfile("spi_master.vcd"); $dumpvars(0,spi_master_tb);
        rst=1; miso=0; @(posedge clk);#1; rst=0;
        mosi_data=8'hA5; start=1; saw_done=0;
        @(posedge clk);#1; start=0;
        // Run 40 cycles, track done
        repeat(40) begin @(posedge clk);#1; miso<=mosi; if(done) saw_done=1; end
        if(!saw_done)begin $display("FAIL spi done never seen");errors=errors+1;end
        if(errors==0) $display("PASS: SPI Master test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
