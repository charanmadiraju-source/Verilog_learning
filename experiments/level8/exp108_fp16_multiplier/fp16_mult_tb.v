`timescale 1ns/1ps
module fp16_mult_tb;
    reg [15:0] a,b; wire [15:0] result;
    fp16_mult uut(.a(a),.b(b),.result(result));
    integer errors=0;
    initial begin
        $dumpfile("fp16_mult.vcd"); $dumpvars(0,fp16_mult_tb);
        // 1.0 * 1.0 = 1.0
        a=16'b0_01111_0000000000; b=16'b0_01111_0000000000; #10;
        if(result!==16'b0_01111_0000000000)begin $display("FAIL 1.0*1.0=%b",result);errors=errors+1;end
        // 2.0 * 2.0 = 4.0
        // 2.0 = 0_10000_0000000000, 4.0 = 0_10001_0000000000
        a=16'b0_10000_0000000000; b=16'b0_10000_0000000000; #10;
        if(result!==16'b0_10001_0000000000)begin $display("FAIL 2.0*2.0=%b",result);errors=errors+1;end
        if(errors==0) $display("PASS: FP16 Multiplier test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
