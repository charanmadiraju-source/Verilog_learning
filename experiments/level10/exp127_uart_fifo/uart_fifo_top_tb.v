`timescale 1ns/1ps
module uart_fifo_top_tb;
    reg clk=0,rst; reg [7:0] tx_data; reg tx_start,rx_fifo_rd;
    wire tx_busy; wire [7:0] rx_fifo_out; wire rx_fifo_empty;
    always #5 clk=~clk;
    uart_fifo_top #(.BAUD_DIV(4),.DEPTH(8)) uut(
        .clk(clk),.rst(rst),.tx_data(tx_data),.tx_start(tx_start),
        .tx_busy(tx_busy),.rx_fifo_out(rx_fifo_out),.rx_fifo_empty(rx_fifo_empty),.rx_fifo_rd(rx_fifo_rd));
    integer errors=0;
    initial begin
        $dumpfile("uart_fifo_top.vcd"); $dumpvars(0,uart_fifo_top_tb);
        rst=1; @(posedge clk);#1; rst=0;
        tx_data=8'hA5; tx_start=1; rx_fifo_rd=0;
        @(posedge clk);#1; tx_start=0;
        // Wait for transfer and FIFO to fill
        repeat(60) @(posedge clk); #1;
        if(rx_fifo_empty)begin $display("FAIL FIFO empty after transfer");errors=errors+1;end
        else begin
            rx_fifo_rd=1; @(posedge clk);#1; rx_fifo_rd=0;
        end
        if(errors==0) $display("PASS: UART+FIFO test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
