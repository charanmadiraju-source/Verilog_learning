// 1-to-2 Demultiplexer
// sel=0 -> y0=in, y1=0
// sel=1 -> y0=0,  y1=in
module demux_1to2 (
    input  in,
    input  sel,
    output y0,
    output y1
);
    assign y0 = in & ~sel;
    assign y1 = in &  sel;
endmodule
