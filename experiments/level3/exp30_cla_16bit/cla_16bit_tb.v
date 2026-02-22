`timescale 1ns/1ps
module cla_16bit_tb;
    reg [15:0] a,b; reg cin; wire [15:0] sum; wire cout;
    cla_16bit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    integer errors=0;
    initial begin
        $dumpfile("cla_16bit.vcd"); $dumpvars(0,cla_16bit_tb);
        a=16'd1000;b=16'd2000;cin=0;#10; if({cout,sum}!==3000)begin $display("FAIL 1000+2000");errors=errors+1;end
        a=16'd65535;b=16'd1;cin=0;#10;   if({cout,sum}!==65536)begin $display("FAIL overflow");errors=errors+1;end
        a=16'd32768;b=16'd32768;cin=0;#10;if({cout,sum}!==65536)begin $display("FAIL 32768+32768");errors=errors+1;end
        a=16'd0;b=16'd0;cin=0;#10;       if({cout,sum}!==0)begin $display("FAIL 0+0");errors=errors+1;end
        if(errors==0) $display("PASS: 16-bit CLA test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
