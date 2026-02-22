// Experiment 25: 4-bit Even/Odd Parity Generator
// XOR reduction: even parity = XOR of all bits; odd = its complement.
// Input  : data[3:0]
// Outputs: even_parity, odd_parity
module parity_gen (
    input  [3:0] data,
    output even_parity,
    output odd_parity
);
    assign even_parity = ^data;
    assign odd_parity  = ~(^data);
endmodule
