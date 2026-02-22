// Experiment 33: BCD Adder (Single Digit)
// Adds two BCD digits. If sum > 9, adds 6 (correction) and sets carry.
// Inputs : a[3:0], b[3:0], cin
// Outputs: sum[3:0], cout
module bcd_adder (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [4:0] binary_sum;
    wire       correction;
    assign binary_sum = a + b + cin;
    assign correction = (binary_sum > 5'd9);
    assign {cout, sum} = correction ? (binary_sum + 5'd6) : binary_sum;
endmodule
