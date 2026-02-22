`timescale 1ns/1ps
module soc_bus_tb;
    reg clk=0,rst;
    reg m0_req,m0_we; reg [7:0] m0_addr,m0_wdata; wire [7:0] m0_rdata; wire m0_ack;
    reg m1_req,m1_we; reg [7:0] m1_addr,m1_wdata; wire [7:0] m1_rdata; wire m1_ack;
    wire s_we; wire [7:0] s_addr,s_wdata; reg [7:0] s_rdata;
    always #5 clk=~clk;
    soc_bus uut(.clk(clk),.rst(rst),.m0_req(m0_req),.m0_we(m0_we),.m0_addr(m0_addr),.m0_wdata(m0_wdata),.m0_rdata(m0_rdata),.m0_ack(m0_ack),
        .m1_req(m1_req),.m1_we(m1_we),.m1_addr(m1_addr),.m1_wdata(m1_wdata),.m1_rdata(m1_rdata),.m1_ack(m1_ack),
        .s_we(s_we),.s_addr(s_addr),.s_wdata(s_wdata),.s_rdata(s_rdata));
    integer errors=0;
    reg saw_m0_ack, saw_m1_ack;
    initial begin
        $dumpfile("soc_bus.vcd"); $dumpvars(0,soc_bus_tb);
        rst=1;m0_req=0;m1_req=0;s_rdata=8'hAB; @(posedge clk);#1; rst=0;
        // M0 write request
        m0_req=1;m0_we=1;m0_addr=8'h10;m0_wdata=8'h55; saw_m0_ack=0;
        repeat(5) begin @(posedge clk);#1; if(m0_ack) saw_m0_ack=1; end
        m0_req=0;
        if(!saw_m0_ack)begin $display("FAIL m0 ack");errors=errors+1;end
        // M1 read request
        m1_req=1;m1_we=0;m1_addr=8'h20; saw_m1_ack=0;
        repeat(5) begin @(posedge clk);#1; if(m1_ack) saw_m1_ack=1; end
        m1_req=0;
        if(!saw_m1_ack)begin $display("FAIL m1 ack");errors=errors+1;end
        if(errors==0) $display("PASS: SoC Bus Interconnect test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
