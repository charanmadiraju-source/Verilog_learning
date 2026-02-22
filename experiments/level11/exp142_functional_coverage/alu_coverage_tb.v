`timescale 1ns/1ps
module alu_coverage_tb;
    reg [1:0] op; reg [7:0] a,b; reg clk=0,rst,en;
    alu_coverage uut(.op(op),.a(a),.b(b),.clk(clk),.rst(rst),.en(en));
    always #5 clk=~clk;
    integer errors=0;
    initial begin
        $dumpfile("alu_coverage.vcd"); $dumpvars(0,alu_coverage_tb);
        rst=1; @(posedge clk);#1; rst=0;
        en=1;
        // Exercise all 4 operations with small inputs
        op=0;a=8'd10;b=8'd5;  @(posedge clk);#1;
        op=1;a=8'd20;b=8'd3;  @(posedge clk);#1;
        op=2;a=8'd15;b=8'd12; @(posedge clk);#1;
        op=3;a=8'd7; b=8'd11; @(posedge clk);#1;
        // Exercise all 4 ops with large inputs
        op=0;a=8'd200;b=8'd150; @(posedge clk);#1;
        op=1;a=8'd200;b=8'd150; @(posedge clk);#1;
        op=2;a=8'd200;b=8'd150; @(posedge clk);#1;
        op=3;a=8'd200;b=8'd150; @(posedge clk);#1;
        en=0;
        // Check coverage
        if(uut.cov_op !== 4'hF) begin $display("FAIL not all ops covered: %b",uut.cov_op);errors=errors+1;end
        if(uut.cov_op_large !== 4'hF) begin $display("FAIL not all large ops covered: %b",uut.cov_op_large);errors=errors+1;end
        if(errors==0) $display("PASS: Functional Coverage test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
