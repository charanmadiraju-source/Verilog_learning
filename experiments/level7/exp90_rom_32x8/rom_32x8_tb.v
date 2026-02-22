`timescale 1ns/1ps
module rom_32x8_tb;
    reg [4:0] addr; wire [7:0] data;
    rom_32x8 uut(.addr(addr),.data(data));
    integer i, errors=0;
    initial begin
        $dumpfile("rom_32x8.vcd"); $dumpvars(0,rom_32x8_tb);
        for(i=0;i<32;i=i+1) begin
            addr=i[4:0]; #5;
            if(data!==i) begin $display("FAIL addr=%0d data=%0d",i,data);errors=errors+1;end
        end
        if(errors==0) $display("PASS: 32x8 ROM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
