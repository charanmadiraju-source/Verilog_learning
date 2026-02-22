`timescale 1ns/1ps
module kogge_stone_4bit_tb;
    reg [3:0] a,b; reg cin; wire [3:0] sum; wire cout;
    kogge_stone_4bit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    integer i,j,errors=0;
    initial begin
        $dumpfile("kogge_stone_4bit.vcd"); $dumpvars(0,kogge_stone_4bit_tb);
        cin=0;
        for(i=0;i<16;i=i+1) for(j=0;j<16;j=j+1) begin
            a=i[3:0];b=j[3:0];#5;
            if({cout,sum}!==(i+j))begin $display("FAIL %0d+%0d=%0d",i,j,{cout,sum});errors=errors+1;end
        end
        if(errors==0) $display("PASS: Kogge-Stone Adder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
