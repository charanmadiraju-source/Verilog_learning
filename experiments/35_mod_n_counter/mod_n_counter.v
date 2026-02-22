// Mod-N Counter (parameterizable)
// Counts from 0 to N-1 then wraps to 0
module mod_n_counter #(parameter N = 10) (
    input  clk,
    input  rst_n,
    output reg [$clog2(N)-1:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 0;
        else if (q == N - 1)
            q <= 0;
        else
            q <= q + 1'b1;
    end
endmodule
