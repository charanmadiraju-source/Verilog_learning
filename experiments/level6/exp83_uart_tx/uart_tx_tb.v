`timescale 1ns/1ps
module uart_tx_tb;
    reg clk=0,rst,tx_start; reg [7:0] tx_data; wire tx, tx_busy;
    always #5 clk=~clk;
    localparam CLK_DIV=4;
    uart_tx #(.CLK_DIV(CLK_DIV)) uut(.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx(tx),.tx_busy(tx_busy));
    integer errors=0;
    reg [7:0] captured; integer i;
    initial begin
        $dumpfile("uart_tx.vcd"); $dumpvars(0,uart_tx_tb);
        rst=1;tx_start=0;tx_data=8'hA5; @(posedge clk);#1; rst=0;
        // Start transmission
        tx_start=1; @(posedge clk);#1; tx_start=0;
        // Wait for start bit (tx goes low)
        wait(tx===1'b0);
        // Skip start bit (CLK_DIV clocks)
        repeat(CLK_DIV) @(posedge clk); #2;
        // Sample 8 data bits
        for(i=0;i<8;i=i+1) begin
            captured[i]=tx;
            repeat(CLK_DIV) @(posedge clk); #2;
        end
        if(captured!==8'hA5) begin $display("FAIL got %h exp A5",captured);errors=errors+1;end
        wait(!tx_busy); #1;
        if(errors==0) $display("PASS: UART TX test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
