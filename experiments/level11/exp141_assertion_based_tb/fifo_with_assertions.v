// Experiment 141: Assertion-Based Verification for Sync FIFO
// Includes simulation-time assertions (immediate) to check protocol.
// Uses the sync_fifo from Level 7 with assertion wrappers.
module fifo_with_assertions #(
    parameter DEPTH=8, WIDTH=8
)(
    input            clk, rst,
    input            wr_en, rd_en,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    output           full, empty
);
    // Instantiate sync FIFO
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] count;
    assign full  = (count == DEPTH);
    assign empty = (count == 0);
    assign dout  = mem[rd_ptr];
    always @(posedge clk or posedge rst) begin
        if (rst) begin wr_ptr<=0; rd_ptr<=0; count<=0; end
        else begin
            if (wr_en && !full) begin mem[wr_ptr]<=din; wr_ptr<=(wr_ptr+1)%DEPTH; count<=count+1; end
            if (rd_en && !empty) begin rd_ptr<=(rd_ptr+1)%DEPTH; count<=count-1; end
            if (wr_en && !full && rd_en && !empty) count<=count; // simultaneous
        end
    end
    // Simulation assertions
    always @(posedge clk) begin
        if (!rst) begin
            // ASSERT: count should never exceed DEPTH
            if (count > DEPTH) $error("ASSERTION FAIL: count=%0d exceeds DEPTH=%0d",count,DEPTH);
            // ASSERT: wr_ptr should be in valid range
            if (wr_ptr >= DEPTH) $error("ASSERTION FAIL: wr_ptr=%0d out of range",wr_ptr);
            // ASSERT: rd_ptr should be in valid range
            if (rd_ptr >= DEPTH) $error("ASSERTION FAIL: rd_ptr=%0d out of range",rd_ptr);
        end
    end
endmodule
