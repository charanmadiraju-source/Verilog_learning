`timescale 1ns/1ps
module sys_timer_tb;
    reg clk=0,rst,we;reg[1:0]reg_addr;reg[31:0]wr_data;wire[31:0]rd_data;wire irq_overflow,irq_compare;
    always #5 clk=~clk;
    sys_timer uut(.clk(clk),.rst(rst),.we(we),.reg_addr(reg_addr),.wr_data(wr_data),.rd_data(rd_data),.irq_overflow(irq_overflow),.irq_compare(irq_compare));
    integer errors=0;reg saw_cmp;
    initial begin
        $dumpfile("sys_timer.vcd");$dumpvars(0,sys_timer_tb);
        rst=1;we=0;@(posedge clk);#1;rst=0;
        // Set compare to 10, enable compare interrupt
        we=1;reg_addr=1;wr_data=32'd10;@(posedge clk);#1;
        we=1;reg_addr=0;wr_data=32'd2;@(posedge clk);#1;we=0;
        saw_cmp=0;repeat(20)begin @(posedge clk);#1;if(irq_compare)saw_cmp=1;end
        if(!saw_cmp)begin $display("FAIL compare irq");errors=errors+1;end
        if(errors==0)$display("PASS: System Timer test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
