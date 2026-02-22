// Experiment 3: 2-Input OR Gate (Behavioral)
// Uses continuous assignment (assign) with the | boolean operator.
// Inputs : a, b
// Outputs: y
module or_gate (
    input  a,
    input  b,
    output y
);
    assign y = a | b;
endmodule
