// Experiment 87: 16x8-bit Single-Port RAM (Sync Read)
// Both write and read are registered on posedge clk.
// Inputs : clk, addr[3:0], din[7:0], we
// Output : dout[7:0] (registered)
module ram_16x8_sync (
    input        clk, we,
    input  [3:0] addr,
    input  [7:0] din,
    output reg [7:0] dout
);
    reg [7:0] mem [0:15];
    always @(posedge clk) begin
        if (we) mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule
