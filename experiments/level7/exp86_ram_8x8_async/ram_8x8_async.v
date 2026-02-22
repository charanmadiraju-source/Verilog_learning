// Experiment 86: 8x8-bit Single-Port RAM (Async Read)
// Write is synchronous; read is combinational (async).
// Inputs : clk, addr[2:0], din[7:0], we
// Output : dout[7:0]
module ram_8x8_async (
    input        clk, we,
    input  [2:0] addr,
    input  [7:0] din,
    output [7:0] dout
);
    reg [7:0] mem [0:7];
    always @(posedge clk) if (we) mem[addr] <= din;
    assign dout = mem[addr];
endmodule
