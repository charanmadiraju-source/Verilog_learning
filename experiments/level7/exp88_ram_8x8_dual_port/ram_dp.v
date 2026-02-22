// Experiment 88: 8x8-bit Dual-Port RAM (1-read, 1-write)
// Independent read/write ports; async read, sync write.
// Inputs : clk, wr_en, wr_addr[2:0], wr_data[7:0], rd_addr[2:0]
// Output : rd_data[7:0]
module ram_dp (
    input        clk, wr_en,
    input  [2:0] wr_addr, rd_addr,
    input  [7:0] wr_data,
    output [7:0] rd_data
);
    reg [7:0] mem [0:7];
    always @(posedge clk) if (wr_en) mem[wr_addr] <= wr_data;
    assign rd_data = mem[rd_addr];
endmodule
