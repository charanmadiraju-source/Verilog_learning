// 4-Bit Synchronous Down Counter
module sync_down_counter_4bit (
    input  clk,
    input  rst_n,
    input  en,
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'hF;
        else if (en)
            q <= q - 1'b1;
    end
endmodule
