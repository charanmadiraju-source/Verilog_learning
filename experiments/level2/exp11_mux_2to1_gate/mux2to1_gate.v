// Experiment 11: 2-to-1 Multiplexer (Gate-Level)
// Basic selection logic using AND/OR/NOT primitives.
// Inputs : a, b, sel
// Output : y  (y = a when sel=0, y = b when sel=1)
module mux2to1_gate (
    input  a,
    input  b,
    input  sel,
    output y
);
    wire sel_n, and0, and1;
    not  g1 (sel_n, sel);
    and  g2 (and0,  a, sel_n);
    and  g3 (and1,  b, sel);
    or   g4 (y,     and0, and1);
endmodule
