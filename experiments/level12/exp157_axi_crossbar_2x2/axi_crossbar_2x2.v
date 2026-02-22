// Experiment 157: AXI4-Lite 2x2 Crossbar
// Two masters, two slaves. Slave 0: addr[7]=0, Slave 1: addr[7]=1
module axi_crossbar_2x2(
    input clk,rst,
    // M0
    input m0_awvalid,input[7:0]m0_awaddr,output reg m0_awready,
    input m0_wvalid,input[7:0]m0_wdata,output reg m0_wready,output reg m0_bvalid,input m0_bready,
    // M1
    input m1_awvalid,input[7:0]m1_awaddr,output reg m1_awready,
    input m1_wvalid,input[7:0]m1_wdata,output reg m1_wready,output reg m1_bvalid,input m1_bready,
    // S0
    output reg s0_awvalid,output reg[7:0]s0_awaddr,input s0_awready,
    output reg s0_wvalid,output reg[7:0]s0_wdata,input s0_wready,input s0_bvalid,output reg s0_bready,
    // S1
    output reg s1_awvalid,output reg[7:0]s1_awaddr,input s1_awready,
    output reg s1_wvalid,output reg[7:0]s1_wdata,input s1_wready,input s1_bvalid,output reg s1_bready
);
    // Simple priority: M0 over M1
    always@(posedge clk or posedge rst)begin
        if(rst)begin m0_awready<=0;m0_wready<=0;m0_bvalid<=0;m1_awready<=0;m1_wready<=0;m1_bvalid<=0;
            s0_awvalid<=0;s0_wvalid<=0;s0_bready<=0;s1_awvalid<=0;s1_wvalid<=0;s1_bready<=0;end
        else begin
            s0_awvalid<=0;s0_wvalid<=0;s1_awvalid<=0;s1_wvalid<=0;
            m0_awready<=0;m0_wready<=0;m1_awready<=0;m1_wready<=0;
            if(m0_awvalid&&m0_wvalid)begin
                if(!m0_awaddr[7])begin s0_awvalid<=1;s0_awaddr<=m0_awaddr;s0_wvalid<=1;s0_wdata<=m0_wdata;
                    m0_awready<=s0_awready;m0_wready<=s0_wready;m0_bvalid<=s0_bvalid;s0_bready<=m0_bready;end
                else begin s1_awvalid<=1;s1_awaddr<=m0_awaddr;s1_wvalid<=1;s1_wdata<=m0_wdata;
                    m0_awready<=s1_awready;m0_wready<=s1_wready;m0_bvalid<=s1_bvalid;s1_bready<=m0_bready;end
            end else if(m1_awvalid&&m1_wvalid)begin
                if(!m1_awaddr[7])begin s0_awvalid<=1;s0_awaddr<=m1_awaddr;s0_wvalid<=1;s0_wdata<=m1_wdata;
                    m1_awready<=s0_awready;m1_wready<=s0_wready;m1_bvalid<=s0_bvalid;s0_bready<=m1_bready;end
                else begin s1_awvalid<=1;s1_awaddr<=m1_awaddr;s1_wvalid<=1;s1_wdata<=m1_wdata;
                    m1_awready<=s1_awready;m1_wready<=s1_wready;m1_bvalid<=s1_bvalid;s1_bready<=m1_bready;end
            end
        end
    end
endmodule
