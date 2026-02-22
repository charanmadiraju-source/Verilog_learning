`timescale 1ns/1ps
module fp_mult_q44_tb;
    reg signed [7:0] a,b; wire signed [7:0] result;
    fp_mult_q44 uut(.a(a),.b(b),.result(result));
    integer errors=0;
    initial begin
        $dumpfile("fp_mult_q44.vcd"); $dumpvars(0,fp_mult_q44_tb);
        // 2.0 * 3.0 = 6.0 in Q4.4: 2.0=8'b00100000, 3.0=8'b00110000, 6.0=8'b01100000
        a=8'b00100000;b=8'b00110000;#10;
        if(result!==8'b01100000)begin $display("FAIL 2.0*3.0=%b",result);errors=errors+1;end
        // 1.0 * 1.0 = 1.0
        a=8'b00010000;b=8'b00010000;#10;
        if(result!==8'b00010000)begin $display("FAIL 1.0*1.0=%b",result);errors=errors+1;end
        if(errors==0) $display("PASS: Q4.4 Fixed-Point Multiplier test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
