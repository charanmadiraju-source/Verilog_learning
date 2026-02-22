`timescale 1ns/1ps
module wb_slave_tb;
    reg wb_clk=0,wb_rst,wb_cyc,wb_stb,wb_we; reg [3:0] wb_adr; reg [7:0] wb_dat_i;
    wire wb_ack; wire [7:0] wb_dat_o;
    always #5 wb_clk=~wb_clk;
    wb_slave uut(.wb_clk(wb_clk),.wb_rst(wb_rst),.wb_cyc(wb_cyc),.wb_stb(wb_stb),.wb_we(wb_we),
        .wb_adr(wb_adr),.wb_dat_i(wb_dat_i),.wb_ack(wb_ack),.wb_dat_o(wb_dat_o));
    integer errors=0;
    initial begin
        $dumpfile("wb_slave.vcd"); $dumpvars(0,wb_slave_tb);
        wb_rst=1;wb_cyc=0;wb_stb=0;wb_we=0; @(posedge wb_clk);#1; wb_rst=0;
        // Write 0x55 to reg 0
        wb_cyc=1;wb_stb=1;wb_we=1;wb_adr=4'h0;wb_dat_i=8'h55; @(posedge wb_clk);#1;
        @(posedge wb_clk);#1; wb_stb=0;wb_cyc=0;
        // Read back reg 0
        wb_cyc=1;wb_stb=1;wb_we=0;wb_adr=4'h0; @(posedge wb_clk);#1;
        @(posedge wb_clk);#1; wb_stb=0;wb_cyc=0;
        if(wb_dat_o!==8'h55)begin $display("FAIL wb_dat_o=0x%h",wb_dat_o);errors=errors+1;end
        if(errors==0) $display("PASS: Wishbone Slave test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
