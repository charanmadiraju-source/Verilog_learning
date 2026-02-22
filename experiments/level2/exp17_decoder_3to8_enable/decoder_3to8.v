// Experiment 17: 3-to-8 Decoder with Enable
// Chip select logic: en=0 disables all outputs.
// Inputs : in[2:0], en
// Output : out[7:0]
module decoder_3to8 (
    input  [2:0] in,
    input        en,
    output [7:0] out
);
    assign out = en ? (8'b00000001 << in) : 8'b00000000;
endmodule
