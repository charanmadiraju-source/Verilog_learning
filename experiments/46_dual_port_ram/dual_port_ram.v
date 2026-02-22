// Dual-Port RAM (one write port, one read port)
// 256 x 8-bit
module dual_port_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 8
)(
    input                    clk,
    // Write port
    input                    we,
    input  [ADDR_WIDTH-1:0]  waddr,
    input  [DATA_WIDTH-1:0]  din,
    // Read port
    input  [ADDR_WIDTH-1:0]  raddr,
    output reg [DATA_WIDTH-1:0] dout
);
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (we)
            mem[waddr] <= din;
        dout <= mem[raddr];
    end
endmodule
