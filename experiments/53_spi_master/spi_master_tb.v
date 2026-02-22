// SPI Master Testbench (loopback: MISO = MOSI)
`timescale 1ns/1ps
module spi_master_tb;
    reg        clk, rst_n, start;
    reg  [7:0] mosi_data;
    wire [7:0] miso_data;
    wire       done, sclk, mosi, cs_n;

    // Loopback: connect MOSI -> MISO
    spi_master #(.CLK_DIV(2)) uut (
        .clk(clk),.rst_n(rst_n),.start(start),
        .mosi_data(mosi_data),.miso(mosi),
        .miso_data(miso_data),.done(done),
        .sclk(sclk),.mosi(mosi),.cs_n(cs_n)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("spi_master.vcd");
        $dumpvars(0, spi_master_tb);
        clk=0; rst_n=0; start=0; mosi_data=8'hC3; #12; rst_n=1; #10;
        start=1; @(posedge clk); #1; start=0;
        @(posedge done); #1;
        if (miso_data !== 8'hC3)
            $display("FAIL: miso_data=%h expected C3", miso_data);
        $display("SPI Master loopback received: %h", miso_data);
        $display("SPI Master test complete.");
        $finish;
    end
endmodule
