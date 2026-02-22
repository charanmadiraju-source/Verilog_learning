// Experiment 8: Full Adder (Gate-Level / Structural)
// Hierarchical design: two Half Adder instances plus an OR gate.
// Demonstrates structural modeling and port mapping.
// Inputs : a, b, cin
// Outputs: sum, cout
module half_adder (
    input  a, b,
    output sum, carry
);
    xor g1 (sum,   a, b);
    and g2 (carry, a, b);
endmodule

module full_adder_gate (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire s1, c1, c2;

    half_adder ha1 (.a(a),  .b(b),   .sum(s1),  .carry(c1));
    half_adder ha2 (.a(s1), .b(cin), .sum(sum),  .carry(c2));
    or         g3  (cout,   c1, c2);
endmodule
