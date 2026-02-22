// Experiment 32: 4-bit Adder/Subtractor with Mode Control
// XOR b with mode: when mode=1, ~b is formed; add mode as cin.
// Inputs : a[3:0], b[3:0], mode (0=add, 1=subtract)
// Outputs: result[3:0], cout
module adder_subtractor_4bit (
    input  [3:0] a, b,
    input        mode,
    output [3:0] result,
    output       cout
);
    wire [3:0] b_in;
    assign b_in = b ^ {4{mode}};
    assign {cout, result} = a + b_in + mode;
endmodule
