// 8-to-1 Multiplexer
module mux_8to1 (
    input  [7:0] in,
    input  [2:0] sel,
    output y
);
    assign y = in[sel];
endmodule
