`timescale 1ns/1ps
module conv_enc_tb;
    reg clk=0,rst,data_in; wire out0,out1;
    always #5 clk=~clk;
    conv_enc uut(.clk(clk),.rst(rst),.data_in(data_in),.out0(out0),.out1(out1));
    integer errors=0;
    initial begin
        $dumpfile("conv_enc.vcd"); $dumpvars(0,conv_enc_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Clock 1: data_in=1, state=00 -> out0=1^0^0=1, out1=1^0=1, new_state=10
        data_in=1; @(posedge clk);#1;
        if(out0!==1||out1!==1)begin $display("FAIL in=1 state00: out=%b%b",out0,out1);errors=errors+1;end
        // Clock 2: data_in=0, state=10 -> out0=0^1^0=1, out1=0^1=1, new_state=01
        data_in=0; @(posedge clk);#1;
        if(out0!==1||out1!==1)begin $display("FAIL in=0 state10: out=%b%b",out0,out1);errors=errors+1;end
        // Clock 3: data_in=1, state=01 -> out0=1^0^1=0, out1=1^0=1, new_state=10
        data_in=1; @(posedge clk);#1;
        if(out0!==0||out1!==1)begin $display("FAIL in=1 state01: out=%b%b",out0,out1);errors=errors+1;end
        if(errors==0) $display("PASS: Convolutional Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
