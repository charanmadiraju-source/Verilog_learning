// Experiment 151: SoC Bus Interconnect (Simple 2-Master, 4-Slave)
// Arbitrates between 2 masters and routes to 4 slaves based on address range.
// Address map: 0x00-0x3F=slave0, 0x40-0x7F=slave1, 0x80-0xBF=slave2, 0xC0-0xFF=slave3
module soc_bus (
    input        clk, rst,
    // Master 0
    input        m0_req, m0_we, input [7:0] m0_addr, m0_wdata, output reg [7:0] m0_rdata, output reg m0_ack,
    // Master 1
    input        m1_req, m1_we, input [7:0] m1_addr, m1_wdata, output reg [7:0] m1_rdata, output reg m1_ack,
    // Slave ports (simplified: single slave memory for demo)
    output reg       s_we, output reg [7:0] s_addr, s_wdata, input [7:0] s_rdata
);
    reg active_master; // 0=m0, 1=m1
    reg busy;
    always @(posedge clk or posedge rst) begin
        if (rst) begin busy<=0; m0_ack<=0; m1_ack<=0; active_master<=0; end
        else begin
            m0_ack<=0; m1_ack<=0; s_we<=0;
            if (!busy) begin
                if (m0_req) begin
                    s_addr<=m0_addr; s_wdata<=m0_wdata; s_we<=m0_we;
                    active_master<=0; busy<=1;
                end else if (m1_req) begin
                    s_addr<=m1_addr; s_wdata<=m1_wdata; s_we<=m1_we;
                    active_master<=1; busy<=1;
                end
            end else begin
                if (active_master==0) begin m0_rdata<=s_rdata; m0_ack<=1; end
                else begin m1_rdata<=s_rdata; m1_ack<=1; end
                busy<=0;
            end
        end
    end
endmodule
