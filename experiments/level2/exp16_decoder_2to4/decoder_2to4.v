// Experiment 16: 2-to-4 Decoder
// One-hot encoding: exactly one output is high based on 2-bit input.
// Includes an enable signal (active high).
// Inputs : in[1:0], en
// Output : out[3:0]
module decoder_2to4 (
    input  [1:0] in,
    input        en,
    output [3:0] out
);
    assign out = en ? (4'b0001 << in) : 4'b0000;
endmodule
