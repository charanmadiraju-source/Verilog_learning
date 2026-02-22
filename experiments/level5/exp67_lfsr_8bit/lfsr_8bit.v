// Experiment 67: 8-bit LFSR with Maximum Length
// Polynomial x^8+x^6+x^5+x^4+1 (taps 7,5,4,3 from MSB, zero-indexed).
// Generates 255-state pseudo-random sequence.
// Inputs : clk, rst
// Output : q[7:0]
module lfsr_8bit (
    input  clk, rst,
    output reg [7:0] q
);
    wire feedback = q[7] ^ q[5] ^ q[4] ^ q[3];
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 8'b00000001;
        else     q <= {q[6:0], feedback};
    end
endmodule
