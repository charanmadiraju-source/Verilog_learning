// Experiment 2: 2-Input AND Gate (Behavioral)
// Uses continuous assignment (assign) with the & boolean operator.
// Inputs : a, b
// Outputs: y
module and_gate (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule
