`timescale 1ns/1ps
module adder_subtractor_4bit_tb;
    reg [3:0] a,b; reg mode; wire [3:0] result; wire cout;
    adder_subtractor_4bit uut(.a(a),.b(b),.mode(mode),.result(result),.cout(cout));
    integer errors=0;
    initial begin
        $dumpfile("adder_subtractor_4bit.vcd"); $dumpvars(0,adder_subtractor_4bit_tb);
        a=4'd9;b=4'd5;mode=0;#10; if(result!==4'd14)begin $display("FAIL 9+5");errors=errors+1;end
        a=4'd9;b=4'd5;mode=1;#10; if(result!==4'd4) begin $display("FAIL 9-5");errors=errors+1;end
        a=4'd3;b=4'd7;mode=0;#10; if(result!==4'd10)begin $display("FAIL 3+7");errors=errors+1;end
        a=4'd3;b=4'd7;mode=1;#10; if(result!==4'd12)begin $display("FAIL 3-7 wrap");errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit Adder/Subtractor test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
