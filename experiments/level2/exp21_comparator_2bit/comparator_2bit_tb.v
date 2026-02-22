`timescale 1ns/1ps
module comparator_2bit_tb;
    reg [1:0] a,b; wire eq,gt,lt;
    comparator_2bit uut(.a(a),.b(b),.eq(eq),.gt(gt),.lt(lt));
    integer i,j,errors=0;
    initial begin
        $dumpfile("comparator_2bit.vcd"); $dumpvars(0,comparator_2bit_tb);
        for(i=0;i<4;i=i+1) for(j=0;j<4;j=j+1) begin
            a=i[1:0]; b=j[1:0]; #10;
            if(eq!=(i==j)||gt!=(i>j)||lt!=(i<j)) begin
                $display("FAIL a=%0d b=%0d",i,j); errors=errors+1; end
        end
        if(errors==0) $display("PASS: 2-bit Comparator test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
