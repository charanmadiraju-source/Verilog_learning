// 2-to-1 Multiplexer
// sel=0 -> y=a,  sel=1 -> y=b
module mux_2to1 (
    input  a,
    input  b,
    input  sel,
    output y
);
    assign y = sel ? b : a;
endmodule
