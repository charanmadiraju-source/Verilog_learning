// Experiment 4: NOT / Inverter Gate
// Uses continuous assignment with the unary ~ operator.
// Inputs : a
// Outputs: y
module not_gate (
    input  a,
    output y
);
    assign y = ~a;
endmodule
