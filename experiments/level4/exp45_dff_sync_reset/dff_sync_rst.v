// Experiment 45: D Flip-Flop with Synchronous Reset
// Reset only takes effect on clock edge.
// Inputs : clk, rst, d
// Output : q
module dff_sync_rst (
    input  clk, rst, d,
    output reg q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else     q <= d;
    end
endmodule
