// UART Receiver
// 8N1 format; samples in the middle of each bit period
module uart_rx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input        clk,
    input        rst_n,
    input        rx,
    output reg [7:0] rx_data,
    output reg       rx_valid   // pulses high for one clock when byte is ready
);
    localparam BIT_PERIOD  = CLK_FREQ / BAUD_RATE;
    localparam HALF_PERIOD = BIT_PERIOD / 2;

    reg [$clog2(BIT_PERIOD)-1:0] baud_cnt;
    reg [3:0] bit_idx;
    reg [7:0] shift_reg;
    reg       busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            busy <= 0; rx_valid <= 0; baud_cnt <= 0; bit_idx <= 0;
        end else begin
            rx_valid <= 0;
            if (!busy && !rx) begin
                // Detected start bit
                baud_cnt <= 0;
                bit_idx  <= 0;
                busy     <= 1;
            end else if (busy) begin
                if (baud_cnt == (bit_idx == 0 ? HALF_PERIOD : BIT_PERIOD) - 1) begin
                    baud_cnt <= 0;
                    if (bit_idx == 0) begin
                        // Centered on start bit – just verify low and advance
                        bit_idx  <= 1;
                    end else if (bit_idx < 9) begin
                        // Sample data bits D0..D7 (bit_idx 1..8)
                        shift_reg <= {rx, shift_reg[7:1]};
                        bit_idx   <= bit_idx + 1'b1;
                    end else begin
                        // Stop bit
                        rx_data  <= shift_reg;
                        rx_valid <= 1'b1;
                        busy     <= 0;
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1'b1;
                end
            end
        end
    end
endmodule
