// Experiment 134: Convolutional Encoder (Rate 1/2, K=3)
// Generator polynomials: g0=111(7), g1=101(5)
// Input  : clk, rst, data_in
// Output : out0, out1 (two coded bits per input bit, registered)
module conv_enc (
    input  clk, rst, data_in,
    output reg out0, out1
);
    reg [1:0] state; // shift register (state[1]=oldest)
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=2'b00; out0<=0; out1<=0; end
        else begin
            out0  <= data_in ^ state[1] ^ state[0]; // g0=111
            out1  <= data_in ^ state[1];             // g1=101
            state <= {data_in, state[1]};
        end
    end
endmodule
