`timescale 1ns/1ps
module subtractor_4bit_tb;
    reg [3:0] a,b; wire [3:0] diff; wire borrow;
    subtractor_4bit uut(.a(a),.b(b),.diff(diff),.borrow(borrow));
    integer errors=0;
    initial begin
        $dumpfile("subtractor_4bit.vcd"); $dumpvars(0,subtractor_4bit_tb);
        a=4'd9;b=4'd5;#10; if(diff!==4'd4||borrow!==0)begin $display("FAIL 9-5");errors=errors+1;end
        a=4'd5;b=4'd9;#10; if(diff!==4'd12||borrow!==1)begin $display("FAIL 5-9 borrow");errors=errors+1;end
        a=4'd7;b=4'd7;#10; if(diff!==4'd0||borrow!==0)begin $display("FAIL 7-7");errors=errors+1;end
        a=4'd0;b=4'd1;#10; if(diff!==4'd15||borrow!==1)begin $display("FAIL 0-1");errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit Subtractor test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
