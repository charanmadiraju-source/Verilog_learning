// Experiment 41: SR Latch (NAND-based, Gate-Level)
// Cross-coupled NAND gates form a basic memory element.
// Inputs : s_n (active-low set), r_n (active-low reset)
// Outputs: q, q_n
module sr_latch_nand (
    input  s_n, r_n,
    output q, q_n
);
    nand g1 (q,   s_n, q_n);
    nand g2 (q_n, r_n, q);
endmodule
