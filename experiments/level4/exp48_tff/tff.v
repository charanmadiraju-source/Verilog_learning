// Experiment 48: T Flip-Flop (Toggle)
// Toggles q when t=1; holds when t=0.
// Inputs : clk, rst, t
// Output : q
module tff (
    input  clk, rst, t,
    output reg q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else if (t) q <= ~q;
    end
endmodule
