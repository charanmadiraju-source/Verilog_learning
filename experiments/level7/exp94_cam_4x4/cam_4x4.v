// Experiment 94: Content Addressable Memory (CAM) - 4 entries x 4-bit
// Parallel compare: checks all entries simultaneously.
// Inputs : clk, wr_en, wr_addr[1:0], wr_data[3:0], search_data[3:0]
// Outputs: match, match_addr[1:0]
module cam_4x4 (
    input        clk, wr_en,
    input  [1:0] wr_addr,
    input  [3:0] wr_data, search_data,
    output       match,
    output reg [1:0] match_addr
);
    reg [3:0] cam_mem [0:3];
    reg [3:0] valid;
    always @(posedge clk) begin
        if (wr_en) begin cam_mem[wr_addr]<=wr_data; valid[wr_addr]<=1; end
    end
    wire [3:0] hit;
    assign hit[0] = valid[0] && (cam_mem[0]==search_data);
    assign hit[1] = valid[1] && (cam_mem[1]==search_data);
    assign hit[2] = valid[2] && (cam_mem[2]==search_data);
    assign hit[3] = valid[3] && (cam_mem[3]==search_data);
    assign match  = |hit;
    always @(*) begin
        casex(hit)
            4'bxxx1: match_addr=2'd0;
            4'bxx10: match_addr=2'd1;
            4'bx100: match_addr=2'd2;
            4'b1000: match_addr=2'd3;
            default: match_addr=2'd0;
        endcase
    end
    integer i;
    initial begin valid=4'b0; for(i=0;i<4;i=i+1) cam_mem[i]=0; end
endmodule
