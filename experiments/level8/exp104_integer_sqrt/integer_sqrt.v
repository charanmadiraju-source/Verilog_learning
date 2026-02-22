// Experiment 104: Integer Square Root (Iterative, 8-bit)
// Uses the digit-by-digit method (non-restoring sqrt).
// Input  : radicand[7:0]
// Output : root[3:0] (floor of sqrt)
module integer_sqrt (
    input  [7:0] radicand,
    output [3:0] root
);
    reg [3:0] r;
    reg [7:0] rem;
    integer i;
    always @(*) begin
        r = 0; rem = radicand;
        for (i = 3; i >= 0; i = i-1) begin
            if (rem >= ((r << 1) + (1 << i)) << i) begin
                rem = rem - (((r << 1) + (1 << i)) << i);
                r   = r | (1 << i);
            end
        end
    end
    assign root = r;
endmodule
