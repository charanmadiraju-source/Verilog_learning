`timescale 1ns/1ps
module pipe_mult_4stage_tb;
    reg clk=0,rst; reg [7:0] a,b; wire [15:0] product;
    always #5 clk=~clk;
    pipe_mult_4stage uut(.clk(clk),.rst(rst),.a(a),.b(b),.product(product));
    integer errors=0;
    initial begin
        $dumpfile("pipe_mult_4stage.vcd"); $dumpvars(0,pipe_mult_4stage_tb);
        rst=1; @(posedge clk);#1; rst=0;
        a=8'd15;b=8'd12;
        repeat(4) @(posedge clk);#1;
        if(product!==16'd180)begin $display("FAIL 15*12=%0d",product);errors=errors+1;end
        if(errors==0) $display("PASS: 4-stage Pipeline Multiplier test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
