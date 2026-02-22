// JK Flip-Flop
// J=0,K=0 -> hold | J=0,K=1 -> reset | J=1,K=0 -> set | J=1,K=1 -> toggle
module jkff (
    input  clk,
    input  rst_n,
    input  j,
    input  k,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            case ({j, k})
                2'b00: q <= q;
                2'b01: q <= 1'b0;
                2'b10: q <= 1'b1;
                2'b11: q <= ~q;
            endcase
    end
endmodule
