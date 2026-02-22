// Experiment 96: 8-bit Carry-Save Adder (CSA)
// 3:2 reduction: adds three numbers, outputs sum and carry vectors.
// Inputs : a[7:0], b[7:0], c[7:0]
// Outputs: sum[7:0], carry[7:0]
module csa_8bit (
    input  [7:0] a, b, c,
    output [7:0] sum, carry
);
    assign sum   = a ^ b ^ c;
    assign carry = ((a & b) | (b & c) | (a & c)) << 1;
endmodule
