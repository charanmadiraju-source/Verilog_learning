`timescale 1ns/1ps
module complete_soc_tb;
    reg clk=0,rst; wire uart_tx;wire[7:0]gpio_out;wire[3:0]leds;wire irq_out;
    always #5 clk=~clk;
    complete_soc uut(.clk(clk),.rst(rst),.uart_rx(1'b1),.uart_tx(uart_tx),.gpio_out(gpio_out),.leds(leds),.irq_out(irq_out));
    integer errors=0;
    initial begin
        $dumpfile("complete_soc.vcd");$dumpvars(0,complete_soc_tb);
        rst=1;@(posedge clk);#1;rst=0;
        // Let CPU execute program
        repeat(20)@(posedge clk);#1;
        if(gpio_out!==8'hA5)begin $display("FAIL gpio_out=%h",gpio_out);errors=errors+1;end
        if(errors==0)$display("PASS: Complete SoC test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
