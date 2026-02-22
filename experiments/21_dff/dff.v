// D Flip-Flop with synchronous and asynchronous reset
module dff (
    input  clk,
    input  rst_n,   // active-low asynchronous reset
    input  d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
