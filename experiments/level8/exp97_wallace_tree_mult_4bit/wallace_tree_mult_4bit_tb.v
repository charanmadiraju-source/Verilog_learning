`timescale 1ns/1ps
module wallace_tree_mult_4bit_tb;
    reg [3:0] a,b; wire [7:0] product;
    wallace_tree_mult_4bit uut(.a(a),.b(b),.product(product));
    integer i,j,errors=0;
    initial begin
        $dumpfile("wallace_tree_mult_4bit.vcd"); $dumpvars(0,wallace_tree_mult_4bit_tb);
        for(i=0;i<16;i=i+1) for(j=0;j<16;j=j+1) begin
            a=i[3:0];b=j[3:0];#5;
            if(product!==(i*j))begin $display("FAIL %0d*%0d",i,j);errors=errors+1;end
        end
        if(errors==0) $display("PASS: Wallace Tree Multiplier test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
