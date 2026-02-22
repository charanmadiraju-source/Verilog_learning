// Experiment 12: 2-to-1 Multiplexer (Conditional Operator)
// Uses the ternary ?: operator for concise dataflow description.
// Inputs : a, b, sel
// Output : y
module mux2to1 (
    input  a,
    input  b,
    input  sel,
    output y
);
    assign y = sel ? b : a;
endmodule
