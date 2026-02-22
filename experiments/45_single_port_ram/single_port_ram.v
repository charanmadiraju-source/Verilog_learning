// Single-Port Synchronous RAM
// 256 x 8-bit
module single_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
)(
    input                    clk,
    input                    we,     // write enable
    input  [ADDR_WIDTH-1:0]  addr,
    input  [DATA_WIDTH-1:0]  din,
    output reg [DATA_WIDTH-1:0] dout
);
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        dout <= mem[addr];
    end
endmodule
