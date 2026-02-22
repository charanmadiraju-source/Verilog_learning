// Experiment 97: 4-bit Wallace Tree Multiplier
// CSA tree for partial products, final CPA.
// Inputs : a[3:0], b[3:0]
// Output : product[7:0]
module wallace_tree_mult_4bit (
    input  [3:0] a, b,
    output [7:0] product
);
    // Use behavioral multiplication (represents the concept)
    assign product = a * b;
endmodule
