// Experiment 37: 4-bit Comparator with Equal/Greater/Less Outputs
// Three-output comparison using relational operators.
// Inputs : a[3:0], b[3:0]
// Outputs: eq, gt, lt
module comparator_egl (
    input  [3:0] a, b,
    output eq, gt, lt
);
    assign eq = (a == b);
    assign gt = (a >  b);
    assign lt = (a <  b);
endmodule
