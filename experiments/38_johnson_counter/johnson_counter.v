// 4-Bit Johnson Counter
// Produces 2*N unique states by feeding the inverted MSB back to the LSB
module johnson_counter (
    input  clk,
    input  rst_n,
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;
        else
            q <= {~q[0], q[3:1]};   // shift right, invert feedback
    end
endmodule
