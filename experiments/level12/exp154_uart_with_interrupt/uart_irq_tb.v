`timescale 1ns/1ps
module uart_irq_tb;
    reg clk=0,rst; reg [7:0] tx_data; reg tx_start,rx_serial; reg [1:0] irq_clear;
    wire tx_serial,tx_busy; wire [7:0] rx_data; wire rx_valid,irq; wire [1:0] irq_pending;
    always #5 clk=~clk;
    uart_irq #(.BAUD_DIV(4)) uut(.clk(clk),.rst(rst),.tx_data(tx_data),.tx_start(tx_start),.rx_serial(rx_serial),
        .irq_clear(irq_clear),.tx_serial(tx_serial),.tx_busy(tx_busy),.rx_data(rx_data),
        .rx_valid(rx_valid),.irq(irq),.irq_pending(irq_pending));
    integer errors=0;
    reg saw_rx_irq;
    initial begin
        $dumpfile("uart_irq.vcd"); $dumpvars(0,uart_irq_tb);
        rst=1;rx_serial=1;tx_start=0;irq_clear=0; @(posedge clk);#1; rst=0;
        // Transmit a byte (loopback tx_serial to rx_serial)
        tx_data=8'h5A; tx_start=1; saw_rx_irq=0;
        @(posedge clk);#1; tx_start=0;
        repeat(80) begin @(posedge clk);#1; rx_serial<=tx_serial; if(irq_pending[0]) saw_rx_irq=1; end
        if(!saw_rx_irq)begin $display("FAIL rx irq not seen");errors=errors+1;end
        if(errors==0) $display("PASS: UART with Interrupt test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
