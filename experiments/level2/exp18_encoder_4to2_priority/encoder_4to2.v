// Experiment 18: 4-to-2 Priority Encoder
// Highest-numbered active input wins. Uses casex with don't-cares.
// Input  : in[3:0]
// Outputs: out[1:0], valid (valid=0 when no input is active)
module encoder_4to2 (
    input  [3:0] in,
    output reg [1:0] out,
    output reg       valid
);
    always @(*) begin
        casex (in)
            4'b1xxx: begin out = 2'd3; valid = 1'b1; end
            4'b01xx: begin out = 2'd2; valid = 1'b1; end
            4'b001x: begin out = 2'd1; valid = 1'b1; end
            4'b0001: begin out = 2'd0; valid = 1'b1; end
            default: begin out = 2'd0; valid = 1'b0; end
        endcase
    end
endmodule
