// Experiment 66: 4-bit LFSR (Linear Feedback Shift Register)
// Polynomial x^4 + x^3 + 1 (taps at bits 3 and 2, 0-indexed from MSB).
// Generates 15-state pseudo-random sequence.
// Inputs : clk, rst
// Output : q[3:0]
module lfsr_4bit (
    input  clk, rst,
    output reg [3:0] q
);
    wire feedback = q[3] ^ q[2];
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b0001;
        else     q <= {q[2:0], feedback};
    end
endmodule
