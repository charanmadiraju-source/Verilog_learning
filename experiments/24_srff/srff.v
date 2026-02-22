// SR Flip-Flop (clocked, synchronous reset)
// S=1,R=0 -> set | S=0,R=1 -> reset | S=0,R=0 -> hold | S=1,R=1 -> invalid
module srff (
    input  clk,
    input  rst_n,
    input  s,
    input  r,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            case ({s, r})
                2'b10: q <= 1'b1;
                2'b01: q <= 1'b0;
                2'b00: q <= q;
                2'b11: q <= 1'bx; // invalid / forbidden state
            endcase
    end
endmodule
