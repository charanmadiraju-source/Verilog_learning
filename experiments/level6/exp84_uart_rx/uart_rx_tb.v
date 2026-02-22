`timescale 1ns/1ps
module uart_rx_tb;
    reg clk=0,rst; wire [7:0] rx_data; wire rx_done;
    reg tx_line=1;
    always #5 clk=~clk;
    localparam CLK_DIV=4;
    uart_rx #(.CLK_DIV(CLK_DIV)) uut(.clk(clk),.rst(rst),.rx(tx_line),.rx_data(rx_data),.rx_done(rx_done));
    integer errors=0, i;
    reg [7:0] send_byte = 8'hA5;
    task send_bit; input b; integer j; begin
        for(j=0;j<CLK_DIV;j=j+1) @(posedge clk);
        tx_line=b;
    end endtask
    initial begin
        $dumpfile("uart_rx.vcd"); $dumpvars(0,uart_rx_tb);
        rst=1;tx_line=1; @(posedge clk);#1; rst=0;
        // Start bit
        @(posedge clk); tx_line=0;
        // Data bits LSB first
        for(i=0;i<8;i=i+1) send_bit(send_byte[i]);
        // Stop bit
        send_bit(1);
        // Wait for rx_done
        repeat(CLK_DIV+2) @(posedge clk); #1;
        if(!rx_done) begin repeat(4) @(posedge clk); #1; end
        if(rx_data!==send_byte)begin $display("FAIL got %h exp %h",rx_data,send_byte);errors=errors+1;end
        if(errors==0) $display("PASS: UART RX test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
