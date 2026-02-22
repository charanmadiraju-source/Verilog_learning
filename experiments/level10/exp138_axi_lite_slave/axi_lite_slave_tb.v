`timescale 1ns/1ps
module axi_lite_slave_tb;
    reg aclk=0,aresetn;
    reg [3:0] awaddr,araddr; reg awvalid,wvalid,bready,arvalid,rready;
    reg [7:0] wdata;
    wire awready,wready,bvalid,arready,rvalid; wire [1:0] bresp,rresp; wire [7:0] rdata;
    always #5 aclk=~aclk;
    axi_lite_slave uut(.aclk(aclk),.aresetn(aresetn),.awaddr(awaddr),.awvalid(awvalid),.awready(awready),
        .wdata(wdata),.wvalid(wvalid),.wready(wready),.bresp(bresp),.bvalid(bvalid),.bready(bready),
        .araddr(araddr),.arvalid(arvalid),.arready(arready),.rdata(rdata),.rresp(rresp),.rvalid(rvalid),.rready(rready));
    integer errors=0;
    initial begin
        $dumpfile("axi_lite_slave.vcd"); $dumpvars(0,axi_lite_slave_tb);
        aresetn=0; awvalid=0;wvalid=0;bready=1;arvalid=0;rready=1;
        @(posedge aclk);#1; aresetn=1;
        // Write 0xAB to address 0x00
        awaddr=4'h0;awvalid=1;wdata=8'hAB;wvalid=1; @(posedge aclk);#1;
        awvalid=0;wvalid=0;
        repeat(3) @(posedge aclk);#1;
        // Read back address 0x00
        araddr=4'h0;arvalid=1; @(posedge aclk);#1; arvalid=0;
        repeat(2) @(posedge aclk);#1;
        if(rdata!==8'hAB)begin $display("FAIL rdata=0x%h exp=0xAB",rdata);errors=errors+1;end
        if(errors==0) $display("PASS: AXI4-Lite Slave test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
