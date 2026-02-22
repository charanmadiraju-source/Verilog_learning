// UART TX Testbench (small BIT_PERIOD for simulation speed)
`timescale 1ns/1ps
module uart_tx_tb;
    reg        clk, rst_n, tx_start;
    reg  [7:0] tx_data;
    wire       tx, tx_busy;

    // Use CLK_FREQ=100, BAUD_RATE=10 -> 10 clocks per bit
    uart_tx #(.CLK_FREQ(100),.BAUD_RATE(10)) uut (
        .clk(clk),.rst_n(rst_n),.tx_start(tx_start),
        .tx_data(tx_data),.tx(tx),.tx_busy(tx_busy)
    );

    always #5 clk = ~clk;

    integer i;
    reg [9:0] received;

    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
        clk=0; rst_n=0; tx_start=0; tx_data=8'hA5; #12; rst_n=1; #10;
        tx_start=1; @(posedge clk); #1; tx_start=0;
        @(negedge tx_busy); #5;
        $display("UART TX test complete. Last tx idle=%b", tx);
        $finish;
    end
endmodule
