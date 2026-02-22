`timescale 1ns/1ps
module spi_master_fsm_tb;
    reg clk=0,rst,start; reg [7:0] tx_data; wire sclk,mosi,cs_n,done; wire [7:0] rx_data;
    always #5 clk=~clk;
    // Loopback mosi -> miso
    spi_master_fsm uut(.clk(clk),.rst(rst),.start(start),.miso(mosi),.tx_data(tx_data),
                       .sclk(sclk),.mosi(mosi),.cs_n(cs_n),.rx_data(rx_data),.done(done));
    integer errors=0;
    initial begin
        $dumpfile("spi_master_fsm.vcd"); $dumpvars(0,spi_master_fsm_tb);
        rst=1;start=0;tx_data=8'hC3; @(posedge clk);#1; rst=0;
        start=1; @(posedge clk);#1; start=0;
        // Wait for done
        repeat(40) @(posedge clk); #1;
        if(!done) begin repeat(10) @(posedge clk); #1; end
        if(rx_data!==8'hC3)begin $display("FAIL loopback got %h exp C3",rx_data);errors=errors+1;end
        if(errors==0) $display("PASS: SPI Master FSM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
