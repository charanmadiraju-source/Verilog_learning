`timescale 1ns/1ps
module irq_ctrl_tb;
    reg clk=0,rst,ack; reg [3:0] irq; wire intr; wire [1:0] irq_id;
    always #5 clk=~clk;
    irq_ctrl uut(.clk(clk),.rst(rst),.ack(ack),.irq(irq),.intr(intr),.irq_id(irq_id));
    integer errors=0;
    initial begin
        $dumpfile("irq_ctrl.vcd"); $dumpvars(0,irq_ctrl_tb);
        rst=1;ack=0;irq=0; @(posedge clk);#1; rst=0;
        irq=4'b0001; @(posedge clk);#1; if(!intr||irq_id!==0)begin $display("FAIL irq0");errors=errors+1;end
        irq=4'b0101; @(posedge clk);#1; if(!intr||irq_id!==2)begin $display("FAIL priority irq2");errors=errors+1;end
        irq=4'b1000; @(posedge clk);#1; if(!intr||irq_id!==3)begin $display("FAIL irq3");errors=errors+1;end
        ack=1;       @(posedge clk);#1; ack=0;irq=0;
        @(posedge clk);#1; if(intr!==0)begin $display("FAIL intr not cleared");errors=errors+1;end
        if(errors==0) $display("PASS: Interrupt Controller test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
