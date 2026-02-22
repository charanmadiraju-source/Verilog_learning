`timescale 1ns/1ps
module bcd_adder_tb;
    reg [3:0] a,b; reg cin; wire [3:0] sum; wire cout;
    bcd_adder uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    integer errors=0;
    initial begin
        $dumpfile("bcd_adder.vcd"); $dumpvars(0,bcd_adder_tb);
        a=4'd3;b=4'd4;cin=0;#10; if(cout!==0||sum!==4'd7)  begin $display("FAIL 3+4");errors=errors+1;end
        a=4'd7;b=4'd5;cin=0;#10; if(cout!==1||sum!==4'd2)  begin $display("FAIL 7+5=12");errors=errors+1;end
        a=4'd9;b=4'd9;cin=0;#10; if(cout!==1||sum!==4'd8)  begin $display("FAIL 9+9=18");errors=errors+1;end
        a=4'd9;b=4'd9;cin=1;#10; if(cout!==1||sum!==4'd9)  begin $display("FAIL 9+9+1=19");errors=errors+1;end
        a=4'd5;b=4'd5;cin=0;#10; if(cout!==1||sum!==4'd0)  begin $display("FAIL 5+5=10");errors=errors+1;end
        if(errors==0) $display("PASS: BCD Adder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
