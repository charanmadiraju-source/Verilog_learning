`timescale 1ns/1ps
module fp16_adder_tb;
    reg [15:0] a,b; wire [15:0] result;
    fp16_adder uut(.a(a),.b(b),.result(result));
    integer errors=0;
    initial begin
        $dumpfile("fp16_adder.vcd"); $dumpvars(0,fp16_adder_tb);
        // 1.0 + 1.0 = 2.0
        // FP16 1.0 = 0_01111_0000000000
        // FP16 2.0 = 0_10000_0000000000
        a=16'b0_01111_0000000000; b=16'b0_01111_0000000000; #10;
        if(result!==16'b0_10000_0000000000)begin $display("FAIL 1.0+1.0=%b",result);errors=errors+1;end
        // 1.0 + (-1.0) = 0
        a=16'b0_01111_0000000000; b=16'b1_01111_0000000000; #10;
        if(result[14:10]!==5'b0)begin $display("FAIL 1.0+(-1.0) exp=%b",result[14:10]);errors=errors+1;end
        if(errors==0) $display("PASS: FP16 Adder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
