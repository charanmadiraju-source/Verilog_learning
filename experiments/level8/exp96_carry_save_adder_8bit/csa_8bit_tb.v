`timescale 1ns/1ps
module csa_8bit_tb;
    reg [7:0] a,b,c; wire [7:0] sum,carry;
    csa_8bit uut(.a(a),.b(b),.c(c),.sum(sum),.carry(carry));
    integer errors=0;
    initial begin
        $dumpfile("csa_8bit.vcd"); $dumpvars(0,csa_8bit_tb);
        a=8'd10;b=8'd20;c=8'd30;#10;
        if((sum+carry)!==(a+b+c))begin $display("FAIL 10+20+30");errors=errors+1;end
        a=8'd100;b=8'd50;c=8'd75;#10;
        if((sum+carry)!==(a+b+c))begin $display("FAIL 100+50+75");errors=errors+1;end
        a=8'd0;b=8'd0;c=8'd0;#10;
        if((sum+carry)!==0)begin $display("FAIL 0+0+0");errors=errors+1;end
        if(errors==0) $display("PASS: 8-bit CSA test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
