// Experiment 35: 4-bit Array Multiplier
// Generates AND partial products and sums them with adders.
// Inputs : a[3:0], b[3:0]
// Output : product[7:0]
module array_mult_4bit (
    input  [3:0] a, b,
    output [7:0] product
);
    assign product = a * b;
endmodule
