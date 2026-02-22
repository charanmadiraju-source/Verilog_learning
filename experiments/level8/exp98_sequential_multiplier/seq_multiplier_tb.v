`timescale 1ns/1ps
module seq_multiplier_tb;
    reg clk=0,rst,start; reg [7:0] a,b; wire [15:0] product; wire done;
    always #5 clk=~clk;
    seq_multiplier uut(.clk(clk),.rst(rst),.start(start),.a(a),.b(b),.product(product),.done(done));
    integer errors=0;
    initial begin
        $dumpfile("seq_multiplier.vcd"); $dumpvars(0,seq_multiplier_tb);
        rst=1; @(posedge clk);#1; rst=0;
        a=8'd15;b=8'd12;start=1; @(posedge clk);#1; start=0;
        repeat(12) @(posedge clk); #1;
        if(product!==16'd180)begin $display("FAIL 15*12=%0d",product);errors=errors+1;end
        a=8'd255;b=8'd2;start=1; @(posedge clk);#1; start=0;
        repeat(12) @(posedge clk); #1;
        if(product!==16'd510)begin $display("FAIL 255*2=%0d",product);errors=errors+1;end
        if(errors==0) $display("PASS: Sequential Multiplier test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
