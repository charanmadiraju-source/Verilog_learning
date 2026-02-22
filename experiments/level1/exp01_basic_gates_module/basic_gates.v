// Experiment 1: Basic Gates Module
// Demonstrates all built-in gate primitives:
//   and, or, not, nand, nor, xor, xnor
// Inputs : a, b
// Outputs: out_and, out_or, out_not, out_nand, out_nor, out_xor, out_xnor
module basic_gates (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_not,
    output out_nand,
    output out_nor,
    output out_xor,
    output out_xnor
);
    and  g1 (out_and,  a, b);
    or   g2 (out_or,   a, b);
    not  g3 (out_not,  a);
    nand g4 (out_nand, a, b);
    nor  g5 (out_nor,  a, b);
    xor  g6 (out_xor,  a, b);
    xnor g7 (out_xnor, a, b);
endmodule
