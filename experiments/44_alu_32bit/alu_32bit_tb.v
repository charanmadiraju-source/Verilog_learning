// 32-Bit ALU Testbench
`timescale 1ns/1ps
module alu_32bit_tb;
    reg  [31:0] a, b;
    reg  [2:0]  op;
    wire [31:0] result;
    wire zero, overflow;

    alu_32bit uut (.a(a),.b(b),.op(op),.result(result),.zero(zero),.overflow(overflow));

    initial begin
        $dumpfile("alu_32bit.vcd");
        $dumpvars(0, alu_32bit_tb);
        a=32'd15; b=32'd10;
        op=3'b000; #5; if(result!==25)  $display("FAIL ADD");
        op=3'b001; #5; if(result!==5)   $display("FAIL SUB");
        op=3'b010; #5; if(result!==(15&10)) $display("FAIL AND");
        op=3'b011; #5; if(result!==(15|10)) $display("FAIL OR");
        op=3'b100; #5; if(result!==(15^10)) $display("FAIL XOR");
        op=3'b101; #5; if(result!==~(15|10)) $display("FAIL NOR");
        a=32'd5; b=32'd10;
        op=3'b110; #5; if(result!==1)   $display("FAIL SLT");
        a=32'h0001; b=32'd4;
        op=3'b111; #5; if(result!==32'h0010) $display("FAIL SLL");
        $display("32-Bit ALU test complete.");
        $finish;
    end
endmodule
