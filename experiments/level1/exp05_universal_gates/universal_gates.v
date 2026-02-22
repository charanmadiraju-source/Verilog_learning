// Experiment 5: Universal Gates – NAND and NOR as NOT, AND, OR
// Demonstrates De Morgan's theorem by building NOT, AND, and OR
// using only NAND gates, and again using only NOR gates.
//
// Inputs : a, b
// Outputs (NAND-based): nand_not_a, nand_and, nand_or
// Outputs (NOR-based) : nor_not_a,  nor_and,  nor_or
module universal_gates (
    input  a,
    input  b,
    // NAND-based implementations
    output nand_not_a,   // NOT a  using NAND: NAND(a,a)
    output nand_and,     // AND    using NAND: NAND(NAND(a,b), NAND(a,b))
    output nand_or,      // OR     using NAND: NAND(NAND(a,a), NAND(b,b))
    // NOR-based implementations
    output nor_not_a,    // NOT a  using NOR: NOR(a,a)
    output nor_and,      // AND    using NOR: NOR(NOR(a,a), NOR(b,b))
    output nor_or        // OR     using NOR: NOR(NOR(a,b), NOR(a,b))
);
    // NAND-based
    wire nand_ab, nand_aa, nand_bb;
    nand g1 (nand_not_a, a, a);          // NOT a
    nand g2 (nand_ab,    a, b);
    nand g3 (nand_and,   nand_ab, nand_ab); // AND = NOT(NAND(a,b))
    nand g4 (nand_aa,    a, a);
    nand g5 (nand_bb,    b, b);
    nand g6 (nand_or,    nand_aa, nand_bb); // OR = NAND(NOT a, NOT b)

    // NOR-based
    wire nor_ab, nor_aa, nor_bb;
    nor  g7 (nor_not_a,  a, a);          // NOT a
    nor  g8 (nor_aa,     a, a);
    nor  g9 (nor_bb,     b, b);
    nor  g10(nor_and,    nor_aa, nor_bb); // AND = NOR(NOT a, NOT b)
    nor  g11(nor_ab,     a, b);
    nor  g12(nor_or,     nor_ab, nor_ab); // OR = NOT(NOR(a,b))
endmodule
