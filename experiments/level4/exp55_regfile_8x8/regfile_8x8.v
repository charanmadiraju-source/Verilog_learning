// Experiment 55: 8-bit Register File (8 entries, 2-read 1-write)
// Synchronous write, asynchronous read.
// Inputs : clk, wr_en, wr_addr[2:0], wr_data[7:0], rd_addr0[2:0], rd_addr1[2:0]
// Outputs: rd_data0[7:0], rd_data1[7:0]
module regfile_8x8 (
    input        clk, wr_en,
    input  [2:0] wr_addr, rd_addr0, rd_addr1,
    input  [7:0] wr_data,
    output [7:0] rd_data0, rd_data1
);
    reg [7:0] regs [0:7];
    always @(posedge clk) begin
        if (wr_en) regs[wr_addr] <= wr_data;
    end
    assign rd_data0 = regs[rd_addr0];
    assign rd_data1 = regs[rd_addr1];
endmodule
