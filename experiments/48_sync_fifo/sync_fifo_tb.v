// Synchronous FIFO Testbench
`timescale 1ns/1ps
module sync_fifo_tb;
    reg        clk, rst_n, wr_en, rd_en;
    reg  [7:0] din;
    wire [7:0] dout;
    wire full, empty;

    sync_fifo #(.DATA_WIDTH(8),.ADDR_WIDTH(4)) uut (
        .clk(clk),.rst_n(rst_n),.wr_en(wr_en),.rd_en(rd_en),
        .din(din),.dout(dout),.full(full),.empty(empty)
    );

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("sync_fifo.vcd");
        $dumpvars(0, sync_fifo_tb);
        clk=0; rst_n=0; wr_en=0; rd_en=0; #12; rst_n=1;
        if (!empty) $display("FAIL: should be empty after reset");
        // Write 8 items
        wr_en=1;
        for (i=0; i<8; i=i+1) begin din=8'd10+i; @(posedge clk); #1; end
        wr_en=0; #5;
        // Read back 8 items
        rd_en=1;
        for (i=0; i<8; i=i+1) begin
            @(posedge clk); #1;
            if (dout !== 8'd10+i) $display("FAIL rd[%0d]=%0d exp=%0d", i, dout, 10+i);
        end
        rd_en=0;
        if (!empty) $display("FAIL: should be empty after reads");
        $display("Synchronous FIFO test complete.");
        $finish;
    end
endmodule
