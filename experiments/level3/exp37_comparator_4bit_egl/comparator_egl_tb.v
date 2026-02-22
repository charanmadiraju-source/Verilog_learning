`timescale 1ns/1ps
module comparator_egl_tb;
    reg [3:0] a,b; wire eq,gt,lt;
    comparator_egl uut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
    integer errors=0;
    initial begin
        $dumpfile("comparator_egl.vcd"); $dumpvars(0,comparator_egl_tb);
        a=4'd5;b=4'd5;#10; if(eq!==1||gt!==0||lt!==0)begin $display("FAIL eq");errors=errors+1;end
        a=4'd8;b=4'd3;#10; if(eq!==0||gt!==1||lt!==0)begin $display("FAIL gt");errors=errors+1;end
        a=4'd2;b=4'd9;#10; if(eq!==0||gt!==0||lt!==1)begin $display("FAIL lt");errors=errors+1;end
        if(errors==0) $display("PASS: Comparator EGL test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
