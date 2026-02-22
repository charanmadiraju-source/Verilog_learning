// Experiment 140: DSP MAC Unit (Multiply-Accumulate)
// Computes acc += a * b each clock cycle.
// Inputs : clk, rst, en, a[7:0], b[7:0]
// Outputs: acc[23:0]
module dsp_mac (
    input        clk, rst, en,
    input  signed [7:0]  a, b,
    output reg signed [23:0] acc
);
    always @(posedge clk or posedge rst) begin
        if (rst) acc <= 0;
        else if (en) acc <= acc + (a * b);
    end
endmodule
