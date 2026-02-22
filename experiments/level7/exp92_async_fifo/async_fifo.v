// Experiment 92: Asynchronous FIFO (Clock Domain Crossing)
// Uses Gray code pointers and 2-flop synchronizers.
// Parameters: DEPTH=8, WIDTH=8
module async_fifo #(parameter DEPTH=8, WIDTH=8) (
    input              wr_clk, rd_clk, rst,
    input              wr_en, rd_en,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    output             full, empty
);
    localparam PTR_W = $clog2(DEPTH);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    // Binary and Gray pointers
    reg [PTR_W:0] wr_bin, rd_bin;
    reg [PTR_W:0] wr_gray, rd_gray;
    // Synchronized pointers
    reg [PTR_W:0] wr_gray_sync1, wr_gray_sync2;
    reg [PTR_W:0] rd_gray_sync1, rd_gray_sync2;
    // Write side
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin wr_bin<=0; wr_gray<=0; end
        else if (wr_en && !full) begin
            mem[wr_bin[PTR_W-1:0]] <= din;
            wr_bin  <= wr_bin + 1;
            wr_gray <= (wr_bin+1) ^ ((wr_bin+1)>>1);
        end
    end
    // Read side
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin rd_bin<=0; rd_gray<=0; end
        else if (rd_en && !empty) begin
            rd_bin  <= rd_bin + 1;
            rd_gray <= (rd_bin+1) ^ ((rd_bin+1)>>1);
        end
    end
    // 2-flop sync: wr_gray -> rd_clk
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin wr_gray_sync1<=0; wr_gray_sync2<=0; end
        else begin wr_gray_sync1<=wr_gray; wr_gray_sync2<=wr_gray_sync1; end
    end
    // 2-flop sync: rd_gray -> wr_clk
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin rd_gray_sync1<=0; rd_gray_sync2<=0; end
        else begin rd_gray_sync1<=rd_gray; rd_gray_sync2<=rd_gray_sync1; end
    end
    assign dout  = mem[rd_bin[PTR_W-1:0]];
    assign empty = (wr_gray_sync2 == rd_gray);
    assign full  = (wr_gray[PTR_W]!=rd_gray_sync2[PTR_W]) &&
                   (wr_gray[PTR_W-1]!=rd_gray_sync2[PTR_W-1]) &&
                   (wr_gray[PTR_W-2:0]==rd_gray_sync2[PTR_W-2:0]);
endmodule
