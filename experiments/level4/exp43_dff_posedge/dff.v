// Experiment 43: D Flip-Flop (Positive Edge)
// Samples d on the rising edge of clk using non-blocking assignment.
// Inputs : clk, d
// Output : q
module dff (
    input  clk, d,
    output reg q
);
    always @(posedge clk) q <= d;
endmodule
