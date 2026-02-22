// Experiment 115: Superscalar ALU (2 independent operations per cycle)
// Two 4-bit ALUs operating in parallel.
// Inputs : clk, a0[3:0], b0[3:0], op0[1:0], a1[3:0], b1[3:0], op1[1:0]
// Outputs: res0[3:0], res1[3:0]
module superscalar_alu (
    input  [3:0] a0, b0, a1, b1,
    input  [1:0] op0, op1,
    output reg [3:0] res0, res1
);
    always @(*) begin
        case (op0)
            2'b00: res0 = a0 + b0;
            2'b01: res0 = a0 - b0;
            2'b10: res0 = a0 & b0;
            2'b11: res0 = a0 | b0;
        endcase
        case (op1)
            2'b00: res1 = a1 + b1;
            2'b01: res1 = a1 - b1;
            2'b10: res1 = a1 & b1;
            2'b11: res1 = a1 | b1;
        endcase
    end
endmodule
