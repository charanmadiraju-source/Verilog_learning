`timescale 1ns/1ps
module superscalar_alu_tb;
    reg [3:0] a0,b0,a1,b1; reg [1:0] op0,op1; wire [3:0] res0,res1;
    superscalar_alu uut(.a0(a0),.b0(b0),.a1(a1),.b1(b1),.op0(op0),.op1(op1),.res0(res0),.res1(res1));
    integer errors=0;
    initial begin
        $dumpfile("superscalar_alu.vcd"); $dumpvars(0,superscalar_alu_tb);
        a0=4'd5;b0=4'd3;op0=2'b00; a1=4'hF;b1=4'hA;op1=2'b10; #10;
        if(res0!==4'd8)begin $display("FAIL res0 add");errors=errors+1;end
        if(res1!==4'hA)begin $display("FAIL res1 and");errors=errors+1;end
        a0=4'd9;b0=4'd4;op0=2'b01; a1=4'h5;b1=4'hA;op1=2'b11; #10;
        if(res0!==4'd5)begin $display("FAIL res0 sub");errors=errors+1;end
        if(res1!==4'hF)begin $display("FAIL res1 or");errors=errors+1;end
        if(errors==0) $display("PASS: Superscalar ALU test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
