`timescale 1ns/1ps
module gpio_ctrl_tb;
    reg clk=0,rst,we,dir_we; reg [1:0] addr; reg [7:0] wr_data,gpio_in;
    wire [7:0] gpio_out,rd_data; wire irq;
    always #5 clk=~clk;
    gpio_ctrl uut(.clk(clk),.rst(rst),.we(we),.dir_we(dir_we),.addr(addr),.wr_data(wr_data),.gpio_in(gpio_in),.gpio_out(gpio_out),.rd_data(rd_data),.irq(irq));
    integer errors=0;
    initial begin
        $dumpfile("gpio_ctrl.vcd"); $dumpvars(0,gpio_ctrl_tb);
        rst=1;we=0;dir_we=0;gpio_in=0; @(posedge clk);#1; rst=0;
        // Write output register
        we=1;addr=2'd0;wr_data=8'hA5; @(posedge clk);#1; we=0;
        // Read back output register
        addr=2'd0; @(posedge clk);#1;
        if(rd_data!==8'hA5)begin $display("FAIL gpio out=%h",rd_data);errors=errors+1;end
        // Set interrupt mask and trigger
        we=1;addr=2'd2;wr_data=8'hFF; @(posedge clk);#1; we=0; // enable all interrupts
        gpio_in=8'h01; @(posedge clk);#1;  // toggle bit 0
        @(posedge clk);#1;
        if(!irq)begin $display("FAIL irq not triggered");errors=errors+1;end
        if(errors==0) $display("PASS: GPIO Controller test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
