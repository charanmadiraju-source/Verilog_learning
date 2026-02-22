// Async FIFO Testbench (same-clock mode for simplicity)
`timescale 1ns/1ps
module async_fifo_tb;
    reg        wclk, rclk, wrst_n, rrst_n, wr_en, rd_en;
    reg  [7:0] din;
    wire [7:0] dout;
    wire wfull, rempty;

    async_fifo #(.DATA_WIDTH(8),.ADDR_WIDTH(4)) uut (
        .wclk(wclk),.rclk(rclk),.wrst_n(wrst_n),.rrst_n(rrst_n),
        .wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),
        .wfull(wfull),.rempty(rempty)
    );

    always #5  wclk = ~wclk;
    always #7  rclk = ~rclk;   // different clock frequencies

    integer i;
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, async_fifo_tb);
        wclk=0; rclk=0; wrst_n=0; rrst_n=0; wr_en=0; rd_en=0; #20;
        wrst_n=1; rrst_n=1; #10;
        // Write 8 items
        wr_en=1;
        for (i=0; i<8; i=i+1) begin din=8'd20+i; @(posedge wclk); end
        wr_en=0; #50;
        // Read 8 items
        rd_en=1;
        repeat(10) @(posedge rclk);
        rd_en=0;
        $display("Async FIFO test complete.");
        $finish;
    end
endmodule
