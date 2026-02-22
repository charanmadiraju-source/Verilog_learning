`timescale 1ns/1ps
module valid_ready_checker_tb;
    reg clk=0,rst,valid,ready; reg [7:0] data;
    valid_ready_checker uut(.clk(clk),.rst(rst),.valid(valid),.ready(ready),.data(data));
    always #5 clk=~clk;
    integer errors=0;
    initial begin
        $dumpfile("valid_ready_checker.vcd"); $dumpvars(0,valid_ready_checker_tb);
        rst=1;valid=0;ready=0;data=0; @(posedge clk);#1; rst=0;
        // Valid protocol: assert valid, hold data, ready comes
        valid=1;data=8'hAB; @(posedge clk);#1;
        ready=1; @(posedge clk);#1; // handshake
        valid=0;ready=0; @(posedge clk);#1;
        // Another valid transfer
        valid=1;data=8'h55; @(posedge clk);#1;  // valid but not ready
        if(uut.error_flag)begin $display("FAIL false protocol error");errors=errors+1;end
        ready=1; @(posedge clk);#1;
        valid=0;ready=0;
        if(uut.error_flag)begin $display("FAIL unexpected error");errors=errors+1;end
        if(errors==0) $display("PASS: Protocol Checker test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
