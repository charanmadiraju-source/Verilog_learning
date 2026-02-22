`timescale 1ns/1ps
module i2c_master_simple_tb;
    reg clk=0,rst,start_xfer; reg [6:0] addr; reg [7:0] wr_data;
    wire sda_out,scl_out,done,ack_received;
    always #5 clk=~clk;
    i2c_master_simple uut(.clk(clk),.rst(rst),.start_xfer(start_xfer),.addr(addr),
        .wr_data(wr_data),.sda_out(sda_out),.scl_out(scl_out),.done(done),.ack_received(ack_received));
    integer errors=0;
    reg saw_done;
    initial begin
        $dumpfile("i2c_master_simple.vcd"); $dumpvars(0,i2c_master_simple_tb);
        rst=1; @(posedge clk);#1; rst=0;
        addr=7'h48; wr_data=8'h5A; start_xfer=1; saw_done=0;
        @(posedge clk);#1; start_xfer=0;
        repeat(50) begin @(posedge clk);#1; if(done) saw_done=1; end
        if(!saw_done)begin $display("FAIL I2C done never seen");errors=errors+1;end
        if(errors==0) $display("PASS: I2C Master test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
