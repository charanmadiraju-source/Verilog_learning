// Asynchronous FIFO using Gray-code pointers
// Write clock: wclk; Read clock: rclk
module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input                    wclk,
    input                    rclk,
    input                    wrst_n,
    input                    rrst_n,
    input                    wr_en,
    input                    rd_en,
    input  [DATA_WIDTH-1:0]  din,
    output reg [DATA_WIDTH-1:0] dout,
    output                   wfull,
    output                   rempty
);
    localparam DEPTH = 1 << ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Binary and Gray pointers (write domain)
    reg [ADDR_WIDTH:0] wbin, wgray;
    // Binary and Gray pointers (read domain)
    reg [ADDR_WIDTH:0] rbin, rgray;
    // Synchronized gray pointers
    reg [ADDR_WIDTH:0] wgray_sync1, wgray_sync2;
    reg [ADDR_WIDTH:0] rgray_sync1, rgray_sync2;

    // Gray code conversion
    function [ADDR_WIDTH:0] bin2gray;
        input [ADDR_WIDTH:0] b;
        begin bin2gray = b ^ (b >> 1); end
    endfunction

    // Write domain
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin wbin <= 0; wgray <= 0; end
        else if (wr_en && !wfull) begin
            mem[wbin[ADDR_WIDTH-1:0]] <= din;
            wbin  <= wbin  + 1'b1;
            wgray <= bin2gray(wbin + 1'b1);
        end
    end

    // Sync read gray pointer into write domain
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin rgray_sync1 <= 0; rgray_sync2 <= 0; end
        else begin rgray_sync1 <= rgray; rgray_sync2 <= rgray_sync1; end
    end

    assign wfull = (wgray == {~rgray_sync2[ADDR_WIDTH:ADDR_WIDTH-1],
                               rgray_sync2[ADDR_WIDTH-2:0]});

    // Read domain
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin rbin <= 0; rgray <= 0; dout <= 0; end
        else if (rd_en && !rempty) begin
            dout  <= mem[rbin[ADDR_WIDTH-1:0]];
            rbin  <= rbin  + 1'b1;
            rgray <= bin2gray(rbin + 1'b1);
        end
    end

    // Sync write gray pointer into read domain
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin wgray_sync1 <= 0; wgray_sync2 <= 0; end
        else begin wgray_sync1 <= wgray; wgray_sync2 <= wgray_sync1; end
    end

    assign rempty = (rgray == wgray_sync2);
endmodule
