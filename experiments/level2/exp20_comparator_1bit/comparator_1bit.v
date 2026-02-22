// Experiment 20: 1-bit Magnitude Comparator
// Demonstrates >, <, == relational operators.
// Inputs : a, b
// Outputs: eq (a==b), gt (a>b), lt (a<b)
module comparator_1bit (
    input  a, b,
    output eq, gt, lt
);
    assign eq = ~(a ^ b);
    assign gt =  a & ~b;
    assign lt = ~a &  b;
endmodule
