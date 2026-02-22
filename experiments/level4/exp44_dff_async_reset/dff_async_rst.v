// Experiment 44: D Flip-Flop with Asynchronous Reset
// rst is active-high; resets q to 0 immediately regardless of clock.
// Inputs : clk, rst, d
// Output : q
module dff_async_rst (
    input  clk, rst, d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 1'b0;
        else     q <= d;
    end
endmodule
