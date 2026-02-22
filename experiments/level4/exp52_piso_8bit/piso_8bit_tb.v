`timescale 1ns/1ps
module piso_8bit_tb;
    reg clk=0,rst,load; reg [7:0] pin; wire sout;
    always #5 clk=~clk;
    piso_8bit uut(.clk(clk),.rst(rst),.load(load),.parallel_in(pin),.sout(sout));
    integer i, errors=0;
    reg [7:0] data = 8'b10110100;
    reg [7:0] captured;
    initial begin
        $dumpfile("piso_8bit.vcd"); $dumpvars(0,piso_8bit_tb);
        rst=1;load=0;pin=0; @(posedge clk);#1; rst=0;
        // Load
        load=1;pin=data; @(posedge clk);#1; load=0;
        // Capture 8 serial bits
        for(i=7;i>=0;i=i-1) begin
            captured[i]=sout; @(posedge clk);#1;
        end
        if(captured!==data) begin $display("FAIL got %b exp %b",captured,data);errors=errors+1;end
        if(errors==0) $display("PASS: PISO 8-bit test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
