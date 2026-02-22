// Experiment 69: Frequency Divider (Divide by 2/4/8/16)
// Each stage toggles at half the frequency of the previous.
// Inputs : clk, rst
// Outputs: clk_div2, clk_div4, clk_div8, clk_div16
module freq_divider (
    input  clk, rst,
    output clk_div2, clk_div4, clk_div8, clk_div16
);
    reg [3:0] cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) cnt <= 4'b0;
        else     cnt <= cnt + 1'b1;
    end
    assign clk_div2  = cnt[0];
    assign clk_div4  = cnt[1];
    assign clk_div8  = cnt[2];
    assign clk_div16 = cnt[3];
endmodule
