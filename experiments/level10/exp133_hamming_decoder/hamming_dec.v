// Experiment 133: Hamming(7,4) Decoder with Single-Error Correction
// Input  : r[6:0] (received codeword, possibly with 1-bit error)
// Output : d[3:0] (corrected data), error, err_pos[2:0]
module hamming_dec (
    input  [6:0] r,
    output [3:0] d,
    output       error,
    output [2:0] err_pos
);
    // Syndrome: re-check parities
    // s1 covers positions 1,3,5,7 (bits 6,4,2,0 of r)
    wire s1 = r[6] ^ r[4] ^ r[2] ^ r[0];
    // s2 covers positions 2,3,6,7 (bits 5,4,1,0 of r)
    wire s2 = r[5] ^ r[4] ^ r[1] ^ r[0];
    // s4 covers positions 4,5,6,7 (bits 3,2,1,0 of r)
    wire s4 = r[3] ^ r[2] ^ r[1] ^ r[0];
    assign err_pos = {s4, s2, s1};
    assign error   = (err_pos != 0);
    // Correct: flip the bit at err_pos (1-indexed: pos 1=r[6], pos 2=r[5], ..., pos 7=r[0])
    wire [6:0] corrected = error ? (r ^ (7'h40 >> (err_pos - 1))) : r;
    // Extract data: positions 3,5,6,7 -> r[4](d[0]),r[2](d[1]),r[1](d[2]),r[0](d[3])
    // d[3]=MSB, d[0]=LSB
    assign d = {corrected[0], corrected[1], corrected[2], corrected[4]};
endmodule
