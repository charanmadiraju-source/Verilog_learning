// Experiment 19: 8-to-3 Priority Encoder
// Highest-numbered active input wins.
// Input  : in[7:0]
// Outputs: out[2:0], valid
module encoder_8to3 (
    input  [7:0] in,
    output reg [2:0] out,
    output reg       valid
);
    always @(*) begin
        casex (in)
            8'b1xxxxxxx: begin out = 3'd7; valid = 1'b1; end
            8'b01xxxxxx: begin out = 3'd6; valid = 1'b1; end
            8'b001xxxxx: begin out = 3'd5; valid = 1'b1; end
            8'b0001xxxx: begin out = 3'd4; valid = 1'b1; end
            8'b00001xxx: begin out = 3'd3; valid = 1'b1; end
            8'b000001xx: begin out = 3'd2; valid = 1'b1; end
            8'b0000001x: begin out = 3'd1; valid = 1'b1; end
            8'b00000001: begin out = 3'd0; valid = 1'b1; end
            default:     begin out = 3'd0; valid = 1'b0; end
        endcase
    end
endmodule
