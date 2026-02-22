// UART RX Testbench – connects TX to RX directly
// Note: compile with uart_tx.v uart_rx.v uart_rx_tb.v
`timescale 1ns/1ps
module uart_rx_tb;
    reg        clk, rst_n, tx_start;
    reg  [7:0] tx_data;
    wire       tx, tx_busy;
    wire [7:0] rx_data;
    wire       rx_valid;

    localparam CLK_F = 100, BAUD = 10;

    uart_tx #(.CLK_FREQ(CLK_F),.BAUD_RATE(BAUD)) u_tx (
        .clk(clk),.rst_n(rst_n),.tx_start(tx_start),
        .tx_data(tx_data),.tx(tx),.tx_busy(tx_busy)
    );

    uart_rx #(.CLK_FREQ(CLK_F),.BAUD_RATE(BAUD)) u_rx (
        .clk(clk),.rst_n(rst_n),.rx(tx),
        .rx_data(rx_data),.rx_valid(rx_valid)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, uart_rx_tb);
        clk=0; rst_n=0; tx_start=0; tx_data=8'hA5; #12; rst_n=1; #10;
        tx_start=1; @(posedge clk); #1; tx_start=0;
        @(posedge rx_valid); #1;
        if (rx_data !== 8'hA5) $display("FAIL: rx_data=%h expected A5", rx_data);
        $display("UART RX received: %h", rx_data);
        $display("UART RX test complete.");
        $finish;
    end
endmodule
