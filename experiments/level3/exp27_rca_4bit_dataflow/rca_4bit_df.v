// Experiment 27: 4-bit Ripple Carry Adder (Dataflow)
// Single assign with concatenation captures carry-out.
// Inputs : a[3:0], b[3:0], cin
// Outputs: sum[3:0], cout
module rca_4bit_df (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    assign {cout, sum} = a + b + cin;
endmodule
