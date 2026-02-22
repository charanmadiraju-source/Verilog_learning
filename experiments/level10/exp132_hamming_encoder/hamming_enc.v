// Experiment 132: Hamming(7,4) Encoder
// Encodes 4 data bits into 7-bit Hamming code.
// Input  : d[3:0] (data bits)
// Output : h[6:0] (hamming codeword: p1,p2,d1,p4,d2,d3,d4)
// Bit numbering (1-based): pos 1,2,4 are parity bits.
module hamming_enc (
    input  [3:0] d,
    output [6:0] h
);
    // h[6]=p1(bit1), h[5]=p2(bit2), h[4]=d[0](bit3)
    // h[3]=p4(bit4), h[2]=d[1](bit5), h[1]=d[2](bit6), h[0]=d[3](bit7)
    wire p1, p2, p4;
    assign p1 = d[0] ^ d[1] ^ d[3]; // bits 3,5,7
    assign p2 = d[0] ^ d[2] ^ d[3]; // bits 3,6,7
    assign p4 = d[1] ^ d[2] ^ d[3]; // bits 5,6,7
    assign h  = {p1, p2, d[0], p4, d[1], d[2], d[3]};
endmodule
