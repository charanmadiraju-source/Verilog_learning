// Experiment 28: 8-bit Ripple Carry Adder
// Demonstrates scalability with wider buses.
// Inputs : a[7:0], b[7:0], cin
// Outputs: sum[7:0], cout
module rca_8bit (
    input  [7:0] a, b,
    input        cin,
    output [7:0] sum,
    output       cout
);
    assign {cout, sum} = a + b + cin;
endmodule
