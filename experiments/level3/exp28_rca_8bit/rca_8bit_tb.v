`timescale 1ns/1ps
module rca_8bit_tb;
    reg [7:0] a,b; reg cin; wire [7:0] sum; wire cout;
    rca_8bit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    integer errors=0;
    initial begin
        $dumpfile("rca_8bit.vcd"); $dumpvars(0,rca_8bit_tb);
        a=8'd200;b=8'd100;cin=0;#10; if({cout,sum}!==300) begin $display("FAIL 200+100");errors=errors+1;end
        a=8'd255;b=8'd1;  cin=0;#10; if({cout,sum}!==256) begin $display("FAIL 255+1");errors=errors+1;end
        a=8'd127;b=8'd128;cin=1;#10; if({cout,sum}!==256) begin $display("FAIL 127+128+1");errors=errors+1;end
        a=8'd0;  b=8'd0;  cin=0;#10; if({cout,sum}!==0)   begin $display("FAIL 0+0");errors=errors+1;end
        if(errors==0) $display("PASS: 8-bit RCA test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
