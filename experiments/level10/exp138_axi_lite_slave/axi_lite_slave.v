// Experiment 138: AXI4-Lite Slave (4 registers)
// Supports read and write transactions with handshaking.
// Signals follow AXI4-Lite spec (simplified).
module axi_lite_slave (
    input        aclk, aresetn,
    // Write address channel
    input  [3:0] awaddr, input awvalid, output reg awready,
    // Write data channel
    input  [7:0] wdata, input wvalid, output reg wready,
    // Write response channel
    output reg [1:0] bresp, output reg bvalid, input bready,
    // Read address channel
    input  [3:0] araddr, input arvalid, output reg arready,
    // Read data channel
    output reg [7:0] rdata, output reg [1:0] rresp, output reg rvalid, input rready
);
    reg [7:0] regs [0:3];
    reg [3:0] wr_addr;
    integer i;
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            awready<=0;wready<=0;bvalid<=0;bresp<=0;arready<=0;rvalid<=0;rresp<=0;rdata<=0;
            for(i=0;i<4;i=i+1) regs[i]<=0;
        end else begin
            // Write address
            if (awvalid && !awready) begin awready<=1; wr_addr<=awaddr[3:2]; end
            else awready<=0;
            // Write data
            if (wvalid && !wready) begin wready<=1; end else wready<=0;
            // Write response
            if (awvalid && wvalid && !bvalid) begin
                regs[awaddr[3:2]] <= wdata;
                bvalid<=1; bresp<=2'b00;
            end else if (bvalid && bready) bvalid<=0;
            // Read
            if (arvalid && !arready) begin
                arready<=1; rdata<=regs[araddr[3:2]]; rvalid<=1; rresp<=2'b00;
            end else arready<=0;
            if (rvalid && rready) rvalid<=0;
        end
    end
endmodule
