// Experiment 7: Half Adder
// XOR produces the sum bit; AND produces the carry bit.
// First exposure to a module with two outputs.
// Inputs : a, b
// Outputs: sum, carry
module half_adder (
    input  a,
    input  b,
    output sum,
    output carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule
