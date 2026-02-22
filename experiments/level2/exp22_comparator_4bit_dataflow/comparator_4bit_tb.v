`timescale 1ns/1ps
module comparator_4bit_tb;
    reg [3:0] a,b; wire eq,gt,lt;
    comparator_4bit uut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
    integer errors=0;
    initial begin
        $dumpfile("comparator_4bit.vcd"); $dumpvars(0,comparator_4bit_tb);
        a=4'd5; b=4'd5;#10; if(eq!==1||gt!==0||lt!==0)begin $display("FAIL 5==5");errors=errors+1;end
        a=4'd9; b=4'd3;#10; if(eq!==0||gt!==1||lt!==0)begin $display("FAIL 9>3");errors=errors+1;end
        a=4'd2; b=4'd7;#10; if(eq!==0||gt!==0||lt!==1)begin $display("FAIL 2<7");errors=errors+1;end
        a=4'd0; b=4'd15;#10;if(eq!==0||gt!==0||lt!==1)begin $display("FAIL 0<15");errors=errors+1;end
        a=4'd15;b=4'd0;#10; if(eq!==0||gt!==1||lt!==0)begin $display("FAIL 15>0");errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit Comparator test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
