// Experiment 142: Functional Coverage Monitor for ALU
// Tracks which ALU operations have been exercised.
// Coverage: 4 operations x 2 input ranges (small/large) = 8 coverage points.
module alu_coverage (
    input  [1:0] op,
    input  [7:0] a, b,
    input        clk, rst, en
);
    // Coverage bins
    reg [7:0] cov_op;        // bit per op (4 ops)
    reg [7:0] cov_op_large;  // op with large inputs (>127)
    integer total_bins = 8, covered_bins;
    always @(posedge clk or posedge rst) begin
        if (rst) begin cov_op<=0; cov_op_large<=0; end
        else if (en) begin
            cov_op[op] <= 1;
            if (a > 127 && b > 127) cov_op_large[op] <= 1;
        end
    end
    always @(posedge clk) begin
        covered_bins = cov_op[0]+cov_op[1]+cov_op[2]+cov_op[3]+
                       cov_op_large[0]+cov_op_large[1]+cov_op_large[2]+cov_op_large[3];
    end
endmodule
