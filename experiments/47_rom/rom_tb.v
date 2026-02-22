// ROM Testbench
`timescale 1ns/1ps
module rom_tb;
    reg  [3:0] addr;
    wire [7:0] data;

    rom uut (.addr(addr),.data(data));

    integer i;
    initial begin
        $dumpfile("rom.vcd");
        $dumpvars(0, rom_tb);
        for (i=0; i<16; i=i+1) begin
            addr=i[3:0]; #10;
            $display("addr=%0d data=%0d", i, data);
        end
        $display("ROM test complete.");
        $finish;
    end
endmodule
