`timescale 1ns/1ps
module alu_8op_tb;
    reg [7:0] a,b; reg [2:0] op; wire [7:0] result; wire zero,carry,overflow;
    alu_8op uut(.a(a),.b(b),.op(op),.result(result),.zero(zero),.carry(carry),.overflow(overflow));
    integer errors=0;
    initial begin
        $dumpfile("alu_8op.vcd"); $dumpvars(0,alu_8op_tb);
        a=8'd100;b=8'd50; op=3'b000;#10; if(result!==8'd150)begin $display("FAIL add");errors=errors+1;end
        a=8'd100;b=8'd50; op=3'b001;#10; if(result!==8'd50) begin $display("FAIL sub");errors=errors+1;end
        a=8'hF0; b=8'h0F; op=3'b010;#10; if(result!==8'h00) begin $display("FAIL AND");errors=errors+1;end
        a=8'hF0; b=8'h0F; op=3'b011;#10; if(result!==8'hFF) begin $display("FAIL OR");errors=errors+1;end
        a=8'hFF; b=8'hF0; op=3'b100;#10; if(result!==8'h0F) begin $display("FAIL XOR");errors=errors+1;end
        a=8'hAA; b=8'd0;  op=3'b101;#10; if(result!==8'h55) begin $display("FAIL NOT");errors=errors+1;end
        a=8'h04; b=8'd0;  op=3'b110;#10; if(result!==8'h08) begin $display("FAIL SHL");errors=errors+1;end
        a=8'h08; b=8'd0;  op=3'b111;#10; if(result!==8'h04) begin $display("FAIL SHR");errors=errors+1;end
        a=8'd200;b=8'd200;op=3'b000;#10; if(carry!==1)       begin $display("FAIL carry");errors=errors+1;end
        a=8'd5;  b=8'd5;  op=3'b001;#10; if(zero!==1)        begin $display("FAIL zero");errors=errors+1;end
        if(errors==0) $display("PASS: ALU 8-op test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
