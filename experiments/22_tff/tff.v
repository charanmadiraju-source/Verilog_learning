// T Flip-Flop (Toggle)
// When t=1 the output toggles on each rising clock edge
module tff (
    input  clk,
    input  rst_n,
    input  t,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule
