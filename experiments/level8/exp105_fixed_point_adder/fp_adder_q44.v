// Experiment 105: 8-bit Fixed-Point Adder (Q4.4 format)
// Q4.4: 4 integer bits + 4 fractional bits. Total 8 bits.
// Overflow detection when signs differ from result.
// Inputs : a[7:0], b[7:0] (signed Q4.4)
// Outputs: result[7:0], overflow
module fp_adder_q44 (
    input  signed [7:0] a, b,
    output signed [7:0] result,
    output overflow
);
    wire signed [8:0] sum_ext = {a[7],a} + {b[7],b};
    assign result   = sum_ext[7:0];
    assign overflow = (sum_ext[8] != sum_ext[7]);
endmodule
