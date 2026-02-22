// Experiment 95: Cache Line (Direct Mapped, 4 lines)
// 4-bit address: tag=addr[3:2], index=addr[1:0].
// Inputs : clk, rst, addr[3:0], din[7:0], wr_en
// Outputs: dout[7:0], hit
module cache_direct (
    input        clk, rst, wr_en,
    input  [3:0] addr,
    input  [7:0] din,
    output [7:0] dout,
    output       hit
);
    reg [7:0] data  [0:3];
    reg [1:0] tags  [0:3];
    reg [3:0] valid;
    wire [1:0] index = addr[1:0];
    wire [1:0] tag   = addr[3:2];
    always @(posedge clk or posedge rst) begin
        if (rst) valid <= 4'b0;
        else if (wr_en) begin
            data[index] <= din;
            tags[index] <= tag;
            valid[index] <= 1;
        end
    end
    assign hit  = valid[index] && (tags[index]==tag);
    assign dout = data[index];
endmodule
