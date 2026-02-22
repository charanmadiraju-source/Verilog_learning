`timescale 1ns/1ps
module axi_crossbar_2x2_tb;
    reg clk=0,rst;
    reg m0_awvalid;reg[7:0]m0_awaddr;wire m0_awready;
    reg m0_wvalid;reg[7:0]m0_wdata;wire m0_wready;wire m0_bvalid;reg m0_bready=1;
    reg m1_awvalid;reg[7:0]m1_awaddr;wire m1_awready;
    reg m1_wvalid;reg[7:0]m1_wdata;wire m1_wready;wire m1_bvalid;reg m1_bready=1;
    wire s0_awvalid;wire[7:0]s0_awaddr;reg s0_awready=1;
    wire s0_wvalid;wire[7:0]s0_wdata;reg s0_wready=1;reg s0_bvalid=1;wire s0_bready;
    wire s1_awvalid;wire[7:0]s1_awaddr;reg s1_awready=1;
    wire s1_wvalid;wire[7:0]s1_wdata;reg s1_wready=1;reg s1_bvalid=1;wire s1_bready;
    always #5 clk=~clk;
    axi_crossbar_2x2 uut(.*);
    integer errors=0;reg saw_ack;
    initial begin
        $dumpfile("axi_xbar.vcd");$dumpvars(0,axi_crossbar_2x2_tb);
        rst=1;m0_awvalid=0;m0_wvalid=0;m1_awvalid=0;m1_wvalid=0;
        @(posedge clk);#1;rst=0;
        m0_awvalid=1;m0_awaddr=8'h10;m0_wvalid=1;m0_wdata=8'hAA;saw_ack=0;
        repeat(5)begin @(posedge clk);#1;if(m0_awready)saw_ack=1;end
        m0_awvalid=0;m0_wvalid=0;
        if(!saw_ack)begin $display("FAIL m0->s0 ack");errors=errors+1;end
        m1_awvalid=1;m1_awaddr=8'h90;m1_wvalid=1;m1_wdata=8'hBB;saw_ack=0;
        repeat(5)begin @(posedge clk);#1;if(m1_awready)saw_ack=1;end
        m1_awvalid=0;m1_wvalid=0;
        if(!saw_ack)begin $display("FAIL m1->s1 ack");errors=errors+1;end
        if(errors==0)$display("PASS: AXI Crossbar 2x2 test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
