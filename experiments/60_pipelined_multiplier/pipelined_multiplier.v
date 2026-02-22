// Pipelined 8-Bit Multiplier (2 pipeline stages)
// Stage 1: split into upper/lower partial products
// Stage 2: add partial products and accumulate
module pipelined_multiplier #(
    parameter WIDTH = 8
)(
    input                   clk,
    input                   rst_n,
    input  [WIDTH-1:0]      a,
    input  [WIDTH-1:0]      b,
    output reg [2*WIDTH-1:0] product
);
    localparam HALF = WIDTH / 2;

    // Pipeline register stage 1
    reg [WIDTH-1:0]     a_reg, b_reg;
    reg [2*WIDTH-1:0]   pp0, pp1, pp2, pp3;

    // Stage 1: Compute partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg<=0; b_reg<=0;
            pp0<=0; pp1<=0; pp2<=0; pp3<=0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            pp0 <= a[HALF-1:0]   * b[HALF-1:0];
            pp1 <= a[WIDTH-1:HALF] * b[HALF-1:0];
            pp2 <= a[HALF-1:0]   * b[WIDTH-1:HALF];
            pp3 <= a[WIDTH-1:HALF] * b[WIDTH-1:HALF];
        end
    end

    // Stage 2: Accumulate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product <= 0;
        else
            product <= pp0
                     + (pp1 << HALF)
                     + (pp2 << HALF)
                     + (pp3 << WIDTH);
    end
endmodule
