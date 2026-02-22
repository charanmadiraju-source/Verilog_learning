`timescale 1ns/1ps
module comparator_1bit_tb;
    reg a,b; wire eq,gt,lt;
    comparator_1bit uut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
    integer errors=0;
    initial begin
        $dumpfile("comparator_1bit.vcd"); $dumpvars(0,comparator_1bit_tb);
        a=0;b=0;#10; if(eq!==1||gt!==0||lt!==0)begin $display("FAIL 0==0");errors=errors+1;end
        a=0;b=1;#10; if(eq!==0||gt!==0||lt!==1)begin $display("FAIL 0<1");errors=errors+1;end
        a=1;b=0;#10; if(eq!==0||gt!==1||lt!==0)begin $display("FAIL 1>0");errors=errors+1;end
        a=1;b=1;#10; if(eq!==1||gt!==0||lt!==0)begin $display("FAIL 1==1");errors=errors+1;end
        if(errors==0) $display("PASS: 1-bit Comparator test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
