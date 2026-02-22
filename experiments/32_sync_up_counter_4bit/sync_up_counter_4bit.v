// 4-Bit Synchronous Up Counter
module sync_up_counter_4bit (
    input  clk,
    input  rst_n,
    input  en,       // count enable
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0;
        else if (en)
            q <= q + 1'b1;
    end
endmodule
