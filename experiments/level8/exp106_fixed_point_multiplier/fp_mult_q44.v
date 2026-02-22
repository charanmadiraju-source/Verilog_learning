// Experiment 106: 8-bit Fixed-Point Multiplier (Q4.4)
// Result is Q8.8 (16 bits), truncated to Q4.4 by taking bits [11:4].
// Inputs : a[7:0], b[7:0] (signed Q4.4)
// Output : result[7:0] (Q4.4, truncated)
module fp_mult_q44 (
    input  signed [7:0] a, b,
    output signed [7:0] result
);
    wire signed [15:0] full_product = a * b;
    assign result = full_product[11:4]; // correct Q4.4 result
endmodule
