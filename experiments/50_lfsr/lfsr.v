// LFSR – 8-bit Fibonacci LFSR
// Feedback taps at 0-based bit positions 7,5,4,3 (equivalent to the
// Xilinx-table polynomial x^8 + x^6 + x^5 + x^4 + 1)
// Generates a maximal-length pseudo-random sequence of 2^8-1 = 255 values
module lfsr #(parameter WIDTH = 8) (
    input  clk,
    input  rst_n,
    input  en,
    output reg [WIDTH-1:0] q
);
    wire feedback = q[7] ^ q[5] ^ q[4] ^ q[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 8'hFF;   // non-zero seed
        else if (en)
            q <= {q[WIDTH-2:0], feedback};
    end
endmodule
