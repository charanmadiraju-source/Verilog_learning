// 2-to-4 Decoder (active-high outputs, enable active-high)
module decoder_2to4 (
    input  [1:0] in,
    input        en,
    output reg [3:0] out
);
    always @(*) begin
        if (en)
            out = 4'b0001 << in;
        else
            out = 4'b0000;
    end
endmodule
