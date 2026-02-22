`timescale 1ns/1ps
module divider_4bit_tb;
    reg [3:0] dividend, divisor;
    wire [3:0] quotient, remainder;
    divider_4bit uut(.dividend(dividend),.divisor(divisor),.quotient(quotient),.remainder(remainder));
    integer errors=0;
    initial begin
        $dumpfile("divider_4bit.vcd"); $dumpvars(0,divider_4bit_tb);
        dividend=4'd9; divisor=4'd3;#10; if(quotient!==3||remainder!==0)begin $display("FAIL 9/3=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=4'd7; divisor=4'd2;#10; if(quotient!==3||remainder!==1)begin $display("FAIL 7/2=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=4'd15;divisor=4'd4;#10; if(quotient!==3||remainder!==3)begin $display("FAIL 15/4=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=4'd0; divisor=4'd5;#10; if(quotient!==0||remainder!==0)begin $display("FAIL 0/5");errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit Divider test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
