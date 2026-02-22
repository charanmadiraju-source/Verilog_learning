// Experiment 34: 2-digit BCD Adder
// Chains two single-digit BCD adders for tens and ones places.
// Inputs : a[7:0], b[7:0] (BCD: a[7:4]=tens_a, a[3:0]=ones_a)
// Outputs: sum[7:0], cout
module bcd_adder_1d (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire [4:0] binary_sum;
    assign binary_sum = a + b + cin;
    assign {cout,sum} = (binary_sum>9) ? (binary_sum+6) : binary_sum;
endmodule

module bcd_adder_2digit (
    input  [7:0] a, b,
    input        cin,
    output [7:0] sum,
    output       cout
);
    wire carry_mid;
    bcd_adder_1d ones(.a(a[3:0]),.b(b[3:0]),.cin(cin),      .sum(sum[3:0]),.cout(carry_mid));
    bcd_adder_1d tens(.a(a[7:4]),.b(b[7:4]),.cin(carry_mid),.sum(sum[7:4]),.cout(cout));
endmodule
