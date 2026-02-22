// Experiment 21: 2-bit Magnitude Comparator
// Multi-bit comparison using relational operators.
// Inputs : a[1:0], b[1:0]
// Outputs: eq, gt, lt
module comparator_2bit (
    input  [1:0] a, b,
    output eq, gt, lt
);
    assign eq = (a == b);
    assign gt = (a >  b);
    assign lt = (a <  b);
endmodule
