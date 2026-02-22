`timescale 1ns/1ps
module siso_8bit_tb;
    reg clk=0,rst,sin; wire sout;
    always #5 clk=~clk;
    siso_8bit uut(.clk(clk),.rst(rst),.sin(sin),.sout(sout));
    integer i, errors=0;
    reg [7:0] data = 8'b10110001;
    initial begin
        $dumpfile("siso_8bit.vcd"); $dumpvars(0,siso_8bit_tb);
        rst=1;sin=0; @(posedge clk);#1; rst=0;
        // Shift in 8 bits MSB first
        for(i=7;i>=0;i=i-1) begin
            sin=data[i]; @(posedge clk);#1;
        end
        // After 8 shifts sout should be MSB (data[7]=1)
        if(sout!==data[7]) begin $display("FAIL sout=%b exp=%b",sout,data[7]);errors=errors+1;end
        if(errors==0) $display("PASS: SISO 8-bit test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
