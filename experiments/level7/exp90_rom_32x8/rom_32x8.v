// Experiment 90: 32x8-bit ROM
// Content initialized in an initial block. addr=data for simplicity.
// Input  : addr[4:0]
// Output : data[7:0]
module rom_32x8 (
    input  [4:0] addr,
    output [7:0] data
);
    reg [7:0] rom [0:31];
    integer i;
    initial begin
        for (i=0; i<32; i=i+1) rom[i] = i[7:0];
    end
    assign data = rom[addr];
endmodule
