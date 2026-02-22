// Experiment 89: 8x8-bit True Dual-Port RAM (2-read, 2-write)
// Two independent clocked ports; both can read and write.
// Port A and Port B, write priority when both write same addr.
module ram_tdp (
    input        clk,
    input        en_a, we_a,
    input  [2:0] addr_a,
    input  [7:0] din_a,
    output reg [7:0] dout_a,
    input        en_b, we_b,
    input  [2:0] addr_b,
    input  [7:0] din_b,
    output reg [7:0] dout_b
);
    reg [7:0] mem [0:7];
    always @(posedge clk) begin
        if (en_a) begin
            if (we_a) mem[addr_a] <= din_a;
            else dout_a <= mem[addr_a];
        end
        if (en_b) begin
            if (we_b) mem[addr_b] <= din_b;
            else dout_b <= mem[addr_b];
        end
    end
endmodule
