`timescale 1ns/1ps
module register_8bit_tb;
    reg clk=0,rst,load; reg [7:0] d; wire [7:0] q;
    always #5 clk=~clk;
    register_8bit uut(.clk(clk),.rst(rst),.load(load),.d(d),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("register_8bit.vcd"); $dumpvars(0,register_8bit_tb);
        rst=1;load=0;d=0; @(posedge clk);#1; rst=0;
        if(q!==8'd0)begin $display("FAIL reset");errors=errors+1;end
        load=1;d=8'hAB; @(posedge clk);#1;
        if(q!==8'hAB)begin $display("FAIL load");errors=errors+1;end
        load=0;d=8'hFF; @(posedge clk);#1;
        if(q!==8'hAB)begin $display("FAIL hold");errors=errors+1;end
        if(errors==0) $display("PASS: 8-bit Register test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
