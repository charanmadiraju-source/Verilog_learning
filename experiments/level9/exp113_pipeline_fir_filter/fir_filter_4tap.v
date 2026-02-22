// Experiment 113: 4-Tap FIR Filter (Pipelined)
// y[n] = h0*x[n] + h1*x[n-1] + h2*x[n-2] + h3*x[n-3]
// Coefficients fixed: h = {1, 2, 2, 1} (low-pass)
// Input  : clk, rst, x_in[7:0] (signed)
// Output : y_out[15:0] (accumulator)
module fir_filter_4tap (
    input        clk, rst,
    input  signed [7:0] x_in,
    output reg signed [15:0] y_out
);
    localparam signed [7:0] H0=8'sd1, H1=8'sd2, H2=8'sd2, H3=8'sd1;
    reg signed [7:0] delay1, delay2, delay3;
    always @(posedge clk or posedge rst) begin
        if (rst) begin delay1<=0; delay2<=0; delay3<=0; y_out<=0; end
        else begin
            delay1 <= x_in;
            delay2 <= delay1;
            delay3 <= delay2;
            y_out  <= H0*x_in + H1*delay1 + H2*delay2 + H3*delay3;
        end
    end
endmodule
