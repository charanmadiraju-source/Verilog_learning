`timescale 1ns/1ps
module regfile_8x8_tb;
    reg clk=0,wr_en; reg [2:0] wr_addr,rd_addr0,rd_addr1; reg [7:0] wr_data;
    wire [7:0] rd_data0,rd_data1;
    always #5 clk=~clk;
    regfile_8x8 uut(.clk(clk),.wr_en(wr_en),.wr_addr(wr_addr),.wr_data(wr_data),
                    .rd_addr0(rd_addr0),.rd_addr1(rd_addr1),.rd_data0(rd_data0),.rd_data1(rd_data1));
    integer errors=0;
    initial begin
        $dumpfile("regfile_8x8.vcd"); $dumpvars(0,regfile_8x8_tb);
        wr_en=0;rd_addr0=0;rd_addr1=0;
        // Write to reg 3
        wr_en=1;wr_addr=3'd3;wr_data=8'hAA; @(posedge clk);#1;
        // Write to reg 5
        wr_addr=3'd5;wr_data=8'h55; @(posedge clk);#1; wr_en=0;
        // Read
        rd_addr0=3'd3;rd_addr1=3'd5;#5;
        if(rd_data0!==8'hAA)begin $display("FAIL read reg3");errors=errors+1;end
        if(rd_data1!==8'h55)begin $display("FAIL read reg5");errors=errors+1;end
        if(errors==0) $display("PASS: Register File test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
