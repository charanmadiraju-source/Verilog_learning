// Experiment 46: D Flip-Flop with Enable
// q only updates when en=1 at clock edge.
// Inputs : clk, rst, en, d
// Output : q
module dff_en (
    input  clk, rst, en, d,
    output reg q
);
    always @(posedge clk) begin
        if (rst)      q <= 1'b0;
        else if (en)  q <= d;
    end
endmodule
