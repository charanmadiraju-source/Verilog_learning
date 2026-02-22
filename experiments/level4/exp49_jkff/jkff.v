// Experiment 49: JK Flip-Flop
// JK=00 hold, JK=01 reset, JK=10 set, JK=11 toggle.
// Inputs : clk, rst, j, k
// Output : q
module jkff (
    input  clk, rst, j, k,
    output reg q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else case ({j,k})
            2'b00: q <= q;
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= ~q;
        endcase
    end
endmodule
