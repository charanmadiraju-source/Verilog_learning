// Experiment 112: 4-Stage Pipelined Multiplier (8x8 -> 16)
// Stage 1-2: partial product generation, Stage 3-4: accumulation.
// Inputs : clk, rst, a[7:0], b[7:0]
// Output : product[15:0] (4-cycle latency)
module pipe_mult_4stage (
    input        clk, rst,
    input  [7:0] a, b,
    output reg [15:0] product
);
    reg [15:0] pp0,pp1,pp2,pp3;
    reg [15:0] s01,s23;
    reg [15:0] p_s1;
    // Stage 1: compute partial products
    always @(posedge clk or posedge rst) begin
        if (rst) begin pp0<=0;pp1<=0;pp2<=0;pp3<=0; end
        else begin
            pp0 <= a * {4'b0, b[3:0]};
            pp1 <= a * {4'b0, b[7:4]} << 4;
            pp2 <= 0;
            pp3 <= 0;
        end
    end
    // Stage 2: sum pairs
    always @(posedge clk or posedge rst) begin
        if (rst) begin s01<=0; s23<=0; end
        else begin s01<=pp0+pp1; s23<=pp2+pp3; end
    end
    // Stage 3: final sum
    always @(posedge clk or posedge rst) begin
        if (rst) p_s1<=0;
        else p_s1 <= s01+s23;
    end
    // Stage 4: register
    always @(posedge clk or posedge rst) begin
        if (rst) product<=0;
        else product <= p_s1;
    end
endmodule
