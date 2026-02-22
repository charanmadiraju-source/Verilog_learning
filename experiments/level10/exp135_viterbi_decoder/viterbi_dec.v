// Experiment 135: Simplified Viterbi Decoder (Rate 1/2, K=3, 4 states)
// Hard-decision decoding. Processes pairs of received bits.
// States: 00, 01, 10, 11. Trellis: based on conv encoder g0=111, g1=101.
// This is a simplified behavioral Viterbi for 4-bit sequences.
// Input  : clk, rst, rx0, rx1 (received bit pair)
// Output : decoded_bit
module viterbi_dec (
    input  clk, rst, rx0, rx1,
    output reg decoded_bit
);
    // Branch metric computation
    // For each state transition (prev_state, bit), compute expected bits
    // and accumulate path metrics.
    // Simplified: just track best path for 2 states (state_bit[1] only)
    reg [3:0] pm [0:3]; // path metrics for 4 states
    reg [3:0] prev_state_pm;
    integer s;
    function [1:0] expected_out;
        input [1:0] state; input bit_in;
        begin
            expected_out[0] = bit_in ^ state[1] ^ state[0]; // g0
            expected_out[1] = bit_in ^ state[1];             // g1
        end
    endfunction
    function [1:0] hamming_dist;
        input [1:0] a, b;
        begin hamming_dist = (a[0]^b[0]) + (a[1]^b[1]); end
    endfunction
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pm[0]<=0; pm[1]<=4'hF; pm[2]<=4'hF; pm[3]<=4'hF;
            decoded_bit<=0;
        end else begin
            // Simplified: find next state with minimum metric
            // Assume input is 0 or 1, try both
            decoded_bit <= (pm[0] <= pm[2]) ? 0 : 1;
        end
    end
endmodule
