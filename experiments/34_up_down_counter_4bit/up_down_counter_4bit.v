// 4-Bit Up-Down Counter
// up_down=1 -> count up; up_down=0 -> count down
module up_down_counter_4bit (
    input  clk,
    input  rst_n,
    input  en,
    input  up_down,
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0;
        else if (en)
            q <= up_down ? q + 1'b1 : q - 1'b1;
    end
endmodule
