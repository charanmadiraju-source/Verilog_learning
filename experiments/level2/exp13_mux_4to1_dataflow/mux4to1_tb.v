`timescale 1ns/1ps
module mux4to1_tb;
    reg d0,d1,d2,d3; reg [1:0] sel; wire y;
    mux4to1 uut(.d0(d0),.d1(d1),.d2(d2),.d3(d3),.sel(sel),.y(y));
    integer errors=0;
    initial begin
        $dumpfile("mux4to1.vcd"); $dumpvars(0,mux4to1_tb);
        d0=1;d1=0;d2=0;d3=0;sel=2'b00;#10; if(y!==1) begin $display("FAIL sel=00");errors=errors+1;end
        d0=0;d1=1;d2=0;d3=0;sel=2'b01;#10; if(y!==1) begin $display("FAIL sel=01");errors=errors+1;end
        d0=0;d1=0;d2=1;d3=0;sel=2'b10;#10; if(y!==1) begin $display("FAIL sel=10");errors=errors+1;end
        d0=0;d1=0;d2=0;d3=1;sel=2'b11;#10; if(y!==1) begin $display("FAIL sel=11");errors=errors+1;end
        if(errors==0) $display("PASS: 4-to-1 MUX (dataflow) test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
