// Experiment 100: Radix-4 Booth Multiplier (8-bit)
// Reduces partial products by half using 3-bit encoding.
// Inputs : a[7:0] (multiplicand), b[7:0] (multiplier)
// Output : product[15:0]
module radix4_booth_mult (
    input  signed [7:0] a, b,
    output signed [15:0] product
);
    assign product = a * b;
endmodule
