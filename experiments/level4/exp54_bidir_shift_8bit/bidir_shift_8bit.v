// Experiment 54: 8-bit Bidirectional Shift Register
// mode: 00=hold, 01=shift-left, 10=shift-right, 11=parallel-load
// Inputs : clk, rst, mode[1:0], sin_l (left shift serial in), sin_r (right shift serial in), d[7:0]
// Output : q[7:0]
module bidir_shift_8bit (
    input        clk, rst,
    input  [1:0] mode,
    input        sin_l, sin_r,
    input  [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 8'b0;
        else case (mode)
            2'b00: q <= q;
            2'b01: q <= {q[6:0], sin_l};
            2'b10: q <= {sin_r, q[7:1]};
            2'b11: q <= d;
        endcase
    end
endmodule
