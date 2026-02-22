// Experiment 47: D Flip-Flop with Asynchronous Set and Reset
// Set has higher priority than reset.
// Inputs : clk, set, rst, d
// Output : q
module dff_sr (
    input  clk, set, rst, d,
    output reg q
);
    always @(posedge clk or posedge set or posedge rst) begin
        if      (set) q <= 1'b1;
        else if (rst) q <= 1'b0;
        else          q <= d;
    end
endmodule
