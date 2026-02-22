// Experiment 111: 2-Stage Pipelined Adder
// Stage 1: Add lower 4 bits + capture carry.
// Stage 2: Add upper 4 bits using captured carry.
// Inputs : clk, rst, a[7:0], b[7:0]
// Outputs: sum[7:0], cout (2 cycles latency)
module pipe_adder_2stage (
    input        clk, rst,
    input  [7:0] a, b,
    output reg [7:0] sum,
    output reg       cout
);
    // Stage 1 registers
    reg [3:0]  s1_sum_lo;
    reg        s1_carry;
    reg [3:0]  s1_a_hi, s1_b_hi;
    always @(posedge clk or posedge rst) begin
        if (rst) begin s1_sum_lo<=0; s1_carry<=0; s1_a_hi<=0; s1_b_hi<=0; end
        else begin
            {s1_carry, s1_sum_lo} <= {1'b0,a[3:0]} + {1'b0,b[3:0]};
            s1_a_hi <= a[7:4];
            s1_b_hi <= b[7:4];
        end
    end
    // Stage 2
    always @(posedge clk or posedge rst) begin
        if (rst) begin sum<=0; cout<=0; end
        else begin
            {cout, sum[7:4]} <= {1'b0,s1_a_hi} + {1'b0,s1_b_hi} + s1_carry;
            sum[3:0] <= s1_sum_lo;
        end
    end
endmodule
