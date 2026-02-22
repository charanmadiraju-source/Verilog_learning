// 16-Bit Barrel Shifter
// Shifts input by shamt positions in a single clock cycle
// dir=0: left shift; dir=1: right shift (logical)
module barrel_shifter_16bit (
    input  [15:0] in,
    input  [3:0]  shamt,   // shift amount 0-15
    input         dir,     // 0=left, 1=right
    output [15:0] out
);
    assign out = dir ? (in >> shamt) : (in << shamt);
endmodule
