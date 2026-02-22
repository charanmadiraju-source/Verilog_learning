// ROM (Look-Up Table) – 16-entry sine approximation (quarter wave, 0-90°)
module rom #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] data
);
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    initial begin
        // Quarter-wave sine LUT: sin(i * 90/15 degrees) * 255
        mem[0]  = 8'd0;
        mem[1]  = 8'd17;
        mem[2]  = 8'd34;
        mem[3]  = 8'd50;
        mem[4]  = 8'd66;
        mem[5]  = 8'd81;
        mem[6]  = 8'd95;
        mem[7]  = 8'd108;
        mem[8]  = 8'd120;
        mem[9]  = 8'd130;
        mem[10] = 8'd139;
        mem[11] = 8'd147;
        mem[12] = 8'd153;
        mem[13] = 8'd157;
        mem[14] = 8'd159;
        mem[15] = 8'd159;
    end

    assign data = mem[addr];
endmodule
