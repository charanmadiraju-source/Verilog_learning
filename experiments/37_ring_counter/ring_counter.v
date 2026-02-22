// 4-Bit Ring Counter
// Exactly one bit is '1' and it circulates through the register
// After reset: q=0001; after the 1st clock: q=0010; etc.
module ring_counter (
    input  clk,
    input  rst_n,
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0001;          // seed the single '1'
        else
            q <= {q[2:0], q[3]};   // rotate left
    end
endmodule
