// I2C Master Testbench
`timescale 1ns/1ps
module i2c_master_tb;
    reg        clk, rst_n, start;
    reg  [6:0] addr;
    reg  [7:0] data;
    wire       scl, sda, done;

    i2c_master uut (.clk(clk),.rst_n(rst_n),.start(start),
                    .addr(addr),.data(data),.scl(scl),.sda(sda),.done(done));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("i2c_master.vcd");
        $dumpvars(0, i2c_master_tb);
        clk=0; rst_n=0; start=0; addr=7'h48; data=8'hAB; #12; rst_n=1; #10;
        start=1; @(posedge clk); #1; start=0;
        @(posedge done); #10;
        $display("I2C Master test complete. done=%b", done);
        $finish;
    end
endmodule
