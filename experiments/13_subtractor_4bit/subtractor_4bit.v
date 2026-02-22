// 4-Bit Binary Subtractor (using 2's complement addition)
// diff = a - b  (with borrow-in bin; bout = 1 means borrow occurred)
module subtractor_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        bin,
    output [3:0] diff,
    output       bout
);
    wire [4:0] result;
    assign result = {1'b0, a} - {1'b0, b} - bin;
    assign diff   = result[3:0];
    assign bout   = result[4];   // borrow out
endmodule
