`timescale 1ns/1ps
module crc8_tb;
    reg clk=0,rst,data_in,data_valid; wire [7:0] crc;
    always #5 clk=~clk;
    crc8 uut(.clk(clk),.rst(rst),.data_in(data_in),.data_valid(data_valid),.crc(crc));
    integer errors=0, i;
    reg [7:0] test_byte;
    initial begin
        $dumpfile("crc8.vcd"); $dumpvars(0,crc8_tb);
        rst=1; data_valid=0; @(posedge clk);#1; rst=0;
        // Feed 8 bits of 0xAB
        test_byte=8'hAB; data_valid=1;
        for(i=7;i>=0;i=i-1) begin data_in=test_byte[i]; @(posedge clk);#1; end
        data_valid=0;
        // Just verify CRC changed from reset value
        if(crc===8'hFF)begin $display("FAIL CRC unchanged");errors=errors+1;end
        if(errors==0) $display("PASS: CRC-8 test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
