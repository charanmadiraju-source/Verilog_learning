// Experiment 108: Half-Precision Floating Point Multiplier (FP16)
// Adds exponents (minus bias), multiplies mantissas, normalizes.
module fp16_mult (
    input  [15:0] a, b,
    output [15:0] result
);
    wire        sign_r = a[15] ^ b[15];
    wire [4:0]  exp_a  = a[14:10], exp_b  = b[14:10];
    wire [10:0] man_a  = {1'b1, a[9:0]}, man_b = {1'b1, b[9:0]};
    wire [21:0] man_product = man_a * man_b;
    wire [5:0]  exp_sum  = exp_a + exp_b - 5'd15;
    // Normalize
    wire        norm = man_product[21];
    wire [4:0]  exp_r = norm ? (exp_sum + 1) : exp_sum;
    wire [9:0]  man_r = norm ? man_product[20:11] : man_product[19:10];
    assign result = {sign_r, exp_r[4:0], man_r};
endmodule
