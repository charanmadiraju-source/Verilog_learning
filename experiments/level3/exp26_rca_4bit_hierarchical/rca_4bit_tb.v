`timescale 1ns/1ps
module rca_4bit_tb;
    reg [3:0] a,b; reg cin; wire [3:0] sum; wire cout;
    rca_4bit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    integer i,j,errors=0;
    initial begin
        $dumpfile("rca_4bit.vcd"); $dumpvars(0,rca_4bit_tb);
        for(i=0;i<16;i=i+1) for(j=0;j<16;j=j+1) begin
            a=i[3:0];b=j[3:0];cin=0;#5;
            if({cout,sum}!==(i+j)) begin $display("FAIL a=%0d b=%0d",i,j);errors=errors+1;end
        end
        if(errors==0) $display("PASS: 4-bit RCA (hierarchical) test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
