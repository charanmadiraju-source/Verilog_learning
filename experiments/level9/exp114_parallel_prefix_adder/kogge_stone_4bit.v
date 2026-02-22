// Experiment 114: Carry-Lookahead (Parallel Prefix) Adder (4-bit)
// Computes carries in parallel using generate/propagate signals.
// Inputs : a[3:0], b[3:0], cin
// Outputs: sum[3:0], cout
module kogge_stone_4bit (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [3:0] g = a & b;     // bit generate
    wire [3:0] p = a ^ b;     // bit propagate (also XOR for sum)
    // Carry lookahead
    wire c1 = g[0] | (p[0] & cin);
    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    wire c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
                   | (p[3] & p[2] & p[1] & p[0] & cin);
    assign sum  = p ^ {c3, c2, c1, cin};
    assign cout = c4;
endmodule
