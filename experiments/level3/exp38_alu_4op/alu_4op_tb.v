`timescale 1ns/1ps
module alu_4op_tb;
    reg [3:0] a,b; reg [1:0] op; wire [3:0] result; wire zero;
    alu_4op uut(.a(a),.b(b),.op(op),.result(result),.zero(zero));
    integer errors=0;
    initial begin
        $dumpfile("alu_4op.vcd"); $dumpvars(0,alu_4op_tb);
        a=4'd5;b=4'd3;op=2'b00;#10; if(result!==4'd8) begin $display("FAIL add");errors=errors+1;end
        a=4'd9;b=4'd4;op=2'b01;#10; if(result!==4'd5) begin $display("FAIL sub");errors=errors+1;end
        a=4'hF;b=4'hA;op=2'b10;#10; if(result!==4'hA) begin $display("FAIL and");errors=errors+1;end
        a=4'h5;b=4'hA;op=2'b11;#10; if(result!==4'hF) begin $display("FAIL or");errors=errors+1;end
        a=4'd5;b=4'd5;op=2'b01;#10; if(zero!==1)       begin $display("FAIL zero flag");errors=errors+1;end
        if(errors==0) $display("PASS: ALU 4-op test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
