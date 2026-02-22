// 4-to-16 Decoder using generate loop
module decoder_4to16 (
    input  [3:0] in,
    input        en,
    output [15:0] out
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : dec_bit
            assign out[i] = en & (in == i[3:0]);
        end
    endgenerate
endmodule
