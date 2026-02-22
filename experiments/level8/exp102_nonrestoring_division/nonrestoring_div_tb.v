`timescale 1ns/1ps
module nonrestoring_div_tb;
    reg [7:0] dividend; reg [3:0] divisor;
    wire [7:0] quotient; wire [3:0] remainder;
    nonrestoring_div uut(.dividend(dividend),.divisor(divisor),.quotient(quotient),.remainder(remainder));
    integer errors=0;
    initial begin
        $dumpfile("nonrestoring_div.vcd"); $dumpvars(0,nonrestoring_div_tb);
        dividend=8'd20;divisor=4'd4;#10;
        if(quotient!==5||remainder!==0)begin $display("FAIL 20/4=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=8'd15;divisor=4'd3;#10;
        if(quotient!==5||remainder!==0)begin $display("FAIL 15/3=%0d r%0d",quotient,remainder);errors=errors+1;end
        if(errors==0) $display("PASS: Non-Restoring Division test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
