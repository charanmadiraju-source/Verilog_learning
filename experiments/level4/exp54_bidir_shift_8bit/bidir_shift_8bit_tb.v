`timescale 1ns/1ps
module bidir_shift_8bit_tb;
    reg clk=0,rst,sin_l,sin_r; reg [1:0] mode; reg [7:0] d; wire [7:0] q;
    always #5 clk=~clk;
    bidir_shift_8bit uut(.clk(clk),.rst(rst),.mode(mode),.sin_l(sin_l),.sin_r(sin_r),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("bidir_shift_8bit.vcd"); $dumpvars(0,bidir_shift_8bit_tb);
        rst=1;mode=0;sin_l=0;sin_r=0;d=0; @(posedge clk);#1; rst=0;
        // Load
        mode=2'b11;d=8'b10100101; @(posedge clk);#1;
        if(q!==8'b10100101)begin $display("FAIL load");errors=errors+1;end
        // Hold
        mode=2'b00; @(posedge clk);#1;
        if(q!==8'b10100101)begin $display("FAIL hold");errors=errors+1;end
        // Left shift
        mode=2'b01;sin_l=1; @(posedge clk);#1;
        if(q!==8'b01001011)begin $display("FAIL left shift got %b",q);errors=errors+1;end
        // Right shift
        mode=2'b10;sin_r=1; @(posedge clk);#1;
        if(q!==8'b10100101)begin $display("FAIL right shift got %b",q);errors=errors+1;end
        if(errors==0) $display("PASS: Bidirectional Shift Register test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
