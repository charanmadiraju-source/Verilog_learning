// Experiment 22: 4-bit Magnitude Comparator (Dataflow)
// Uses relational operators directly in assign statements.
// Inputs : a[3:0], b[3:0]
// Outputs: eq, gt, lt
module comparator_4bit (
    input  [3:0] a, b,
    output eq, gt, lt
);
    assign eq = (a == b);
    assign gt = (a >  b);
    assign lt = (a <  b);
endmodule
