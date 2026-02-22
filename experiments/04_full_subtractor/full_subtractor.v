// Full Subtractor built from two Half Subtractors
// Inputs : a, b, bin (borrow-in)
// Outputs: diff, bout (borrow-out)
module half_subtractor (
    input  a, b,
    output diff, borrow
);
    assign diff   = a ^ b;
    assign borrow = (~a) & b;
endmodule

module full_subtractor (
    input  a,
    input  b,
    input  bin,
    output diff,
    output bout
);
    wire d1, br1, br2;

    half_subtractor hs1 (.a(a),  .b(b),   .diff(d1),   .borrow(br1));
    half_subtractor hs2 (.a(d1), .b(bin), .diff(diff),  .borrow(br2));

    assign bout = br1 | br2;
endmodule
