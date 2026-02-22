`timescale 1ns/1ps
module fp_adder_q44_tb;
    reg signed [7:0] a,b; wire signed [7:0] result; wire overflow;
    fp_adder_q44 uut(.a(a),.b(b),.result(result),.overflow(overflow));
    integer errors=0;
    initial begin
        $dumpfile("fp_adder_q44.vcd"); $dumpvars(0,fp_adder_q44_tb);
        // 1.5 + 2.5 = 4.0 in Q4.4: 1.5=8'b00011000, 2.5=8'b00101000, 4.0=8'b01000000
        a=8'b00011000;b=8'b00101000;#10;
        if(result!==8'b01000000||overflow!==0)begin $display("FAIL 1.5+2.5");errors=errors+1;end
        // -1.0 + 1.0 = 0 (in Q4.4: -1=11110000, +1=00010000)
        a=8'b11110000;b=8'b00010000;#10;
        if(result!==8'b00000000||overflow!==0)begin $display("FAIL -1+1");errors=errors+1;end
        if(errors==0) $display("PASS: Q4.4 Fixed-Point Adder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
