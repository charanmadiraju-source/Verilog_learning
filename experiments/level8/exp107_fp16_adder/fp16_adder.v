// Experiment 107: Half-Precision Floating Point Adder (FP16)
// IEEE 754 half-precision: 1 sign, 5 exponent, 10 mantissa bits.
// This is a simplified implementation covering normal numbers.
module fp16_adder (
    input  [15:0] a, b,
    output [15:0] result
);
    wire        sign_a = a[15], sign_b = b[15];
    wire [4:0]  exp_a  = a[14:10], exp_b  = b[14:10];
    wire [10:0] man_a  = {1'b1, a[9:0]}, man_b = {1'b1, b[9:0]};

    reg [15:0] res;
    reg [4:0]  exp_diff;
    reg [10:0] mA, mB;
    reg [11:0] sum_man;
    reg [4:0]  res_exp;
    reg        res_sign;

    always @(*) begin
        // Align: shift smaller exponent
        if (exp_a >= exp_b) begin
            res_exp  = exp_a;
            mA       = man_a;
            mB       = man_b >> (exp_a - exp_b);
        end else begin
            res_exp  = exp_b;
            mA       = man_a >> (exp_b - exp_a);
            mB       = man_b;
        end

        // Add/subtract
        if (sign_a == sign_b) begin
            res_sign = sign_a;
            sum_man  = {1'b0, mA} + {1'b0, mB};
            if (sum_man[11]) begin sum_man = sum_man >> 1; res_exp = res_exp + 1; end
        end else begin
            if (mA >= mB) begin res_sign = sign_a; sum_man = mA - mB; end
            else          begin res_sign = sign_b; sum_man = mB - mA; end
            // Normalize
            if (sum_man != 0) begin
                while (!sum_man[10] && res_exp > 0) begin
                    sum_man = sum_man << 1; res_exp = res_exp - 1;
                end
            end else res_exp = 0;
        end
        res = {res_sign, res_exp, sum_man[9:0]};
    end
    assign result = res;
endmodule
