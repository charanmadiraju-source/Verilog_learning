// Experiment 6: 2-Input XOR Gate
// Uses the ^ operator. XOR is 1 when inputs differ (inequality detection).
// Inputs : a, b
// Outputs: y
module xor_gate (
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule
