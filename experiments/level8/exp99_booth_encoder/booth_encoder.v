// Experiment 99: Booth Encoder (Radix-2, 2-bit)
// Encodes multiplier bits for Booth algorithm.
// Input  : {y[i+1], y[i], y[i-1]} (3-bit group)
// Outputs: neg (negate), zero, two (multiply by 2)
// Encoding: 000->0, 001->+1, 010->+1, 011->+2,
//           100->-2, 101->-1, 110->-1, 111->0
module booth_encoder (
    input  [2:0] y,
    output reg neg, zero
);
    always @(*) begin
        case (y)
            3'b000: begin neg=0; zero=1; end
            3'b001: begin neg=0; zero=0; end
            3'b010: begin neg=0; zero=0; end
            3'b011: begin neg=0; zero=0; end
            3'b100: begin neg=1; zero=0; end
            3'b101: begin neg=1; zero=0; end
            3'b110: begin neg=1; zero=0; end
            3'b111: begin neg=0; zero=1; end
        endcase
    end
endmodule
