`timescale 1ns/1ps
module restoring_div_tb;
    reg [7:0] dividend; reg [3:0] divisor;
    wire [7:0] quotient; wire [3:0] remainder;
    restoring_div uut(.dividend(dividend),.divisor(divisor),.quotient(quotient),.remainder(remainder));
    integer errors=0;
    initial begin
        $dumpfile("restoring_div.vcd"); $dumpvars(0,restoring_div_tb);
        dividend=8'd100;divisor=4'd7;#10;
        if(quotient!==14||remainder!==2)begin $display("FAIL 100/7=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=8'd255;divisor=4'd15;#10;
        if(quotient!==17||remainder!==0)begin $display("FAIL 255/15=%0d r%0d",quotient,remainder);errors=errors+1;end
        dividend=8'd0;divisor=4'd5;#10;
        if(quotient!==0||remainder!==0)begin $display("FAIL 0/5");errors=errors+1;end
        if(errors==0) $display("PASS: Restoring Division test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
