// Experiment 91: Synchronous FIFO (8-deep, 8-bit)
// Uses write/read pointers and counter for full/empty detection.
// Inputs : clk, rst, wr_en, rd_en, din[7:0]
// Outputs: dout[7:0], full, empty
module sync_fifo #(parameter DEPTH=8, WIDTH=8) (
    input              clk, rst, wr_en, rd_en,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    output             full, empty
);
    localparam PTR_W = $clog2(DEPTH);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_W:0]   wr_ptr, rd_ptr, count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin wr_ptr<=0; rd_ptr<=0; count<=0; end
        else begin
            if (wr_en && !full)  begin mem[wr_ptr[PTR_W-1:0]] <= din; wr_ptr <= wr_ptr+1; count<=count+1; end
            if (rd_en && !empty) begin rd_ptr <= rd_ptr+1; count<=count-1; end
        end
    end
    assign dout  = mem[rd_ptr[PTR_W-1:0]];
    assign full  = (count == DEPTH);
    assign empty = (count == 0);
endmodule
