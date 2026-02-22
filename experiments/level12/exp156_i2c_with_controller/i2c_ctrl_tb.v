`timescale 1ns/1ps
module i2c_ctrl_tb;
    reg clk=0,rst,we;reg[1:0]reg_addr;reg[7:0]wr_data;wire[7:0]rd_data;wire sda,scl,done;
    always #5 clk=~clk;
    i2c_ctrl uut(.clk(clk),.rst(rst),.we(we),.reg_addr(reg_addr),.wr_data(wr_data),.rd_data(rd_data),.sda(sda),.scl(scl),.done(done));
    integer errors=0;reg saw_done;
    initial begin
        $dumpfile("i2c_ctrl.vcd");$dumpvars(0,i2c_ctrl_tb);
        rst=1;we=0;@(posedge clk);#1;rst=0;
        we=1;reg_addr=1;wr_data=8'h48;@(posedge clk);#1;
        we=1;reg_addr=2;wr_data=8'hAB;@(posedge clk);#1;
        we=1;reg_addr=0;wr_data=8'h01;@(posedge clk);#1;we=0;
        saw_done=0;repeat(50)begin @(posedge clk);#1;if(done)saw_done=1;end
        if(!saw_done)begin $display("FAIL no done");errors=errors+1;end
        if(errors==0)$display("PASS: I2C Controller test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
