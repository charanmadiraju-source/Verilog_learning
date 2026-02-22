`timescale 1ns/1ps
module barrel_shifter_4bit_tb;
    reg [3:0] in; reg [1:0] shift; reg dir; wire [3:0] out;
    barrel_shifter_4bit uut(.in(in),.shift(shift),.dir(dir),.out(out));
    integer errors=0;
    initial begin
        $dumpfile("barrel_shifter_4bit.vcd"); $dumpvars(0,barrel_shifter_4bit_tb);
        in=4'b0001;shift=2'd0;dir=0;#10; if(out!==4'b0001)begin $display("FAIL L0");errors=errors+1;end
        in=4'b0001;shift=2'd1;dir=0;#10; if(out!==4'b0010)begin $display("FAIL L1");errors=errors+1;end
        in=4'b0001;shift=2'd2;dir=0;#10; if(out!==4'b0100)begin $display("FAIL L2");errors=errors+1;end
        in=4'b0001;shift=2'd3;dir=0;#10; if(out!==4'b1000)begin $display("FAIL L3");errors=errors+1;end
        in=4'b1000;shift=2'd1;dir=1;#10; if(out!==4'b0100)begin $display("FAIL R1");errors=errors+1;end
        in=4'b1000;shift=2'd2;dir=1;#10; if(out!==4'b0010)begin $display("FAIL R2");errors=errors+1;end
        in=4'b1000;shift=2'd3;dir=1;#10; if(out!==4'b0001)begin $display("FAIL R3");errors=errors+1;end
        if(errors==0) $display("PASS: 4-bit Barrel Shifter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
