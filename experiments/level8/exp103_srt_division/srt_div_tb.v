`timescale 1ns/1ps
module srt_div_tb;
    reg [7:0] dividend; reg [3:0] divisor;
    wire [7:0] quotient; wire [3:0] remainder;
    srt_div uut(.dividend(dividend),.divisor(divisor),.quotient(quotient),.remainder(remainder));
    integer errors=0;
    initial begin
        $dumpfile("srt_div.vcd"); $dumpvars(0,srt_div_tb);
        dividend=8'd30;divisor=4'd6;#10;
        if(quotient!==5||remainder!==0)begin $display("FAIL 30/6=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=8'd25;divisor=4'd4;#10;
        if(quotient!==6||remainder!==1)begin $display("FAIL 25/4=%0d r%0d",quotient,remainder);errors=errors+1;end
        if(errors==0) $display("PASS: SRT Division test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
