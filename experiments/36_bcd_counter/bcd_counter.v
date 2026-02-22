// BCD Counter (Mod-10, 0 to 9)
module bcd_counter (
    input  clk,
    input  rst_n,
    output reg [3:0] q,
    output           carry  // pulses high when counter rolls over
);
    assign carry = (q == 4'd9);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'd0;
        else if (q == 4'd9)
            q <= 4'd0;
        else
            q <= q + 1'b1;
    end
endmodule
