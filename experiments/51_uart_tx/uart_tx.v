// UART Transmitter
// 8N1 format: 1 start bit, 8 data bits, 1 stop bit, no parity
// CLK_FREQ / BAUD_RATE = clocks per bit
module uart_tx #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input        clk,
    input        rst_n,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output reg   tx_busy
);
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [$clog2(BIT_PERIOD)-1:0] baud_cnt;
    reg [3:0] bit_idx;
    reg [9:0] shift_reg;   // {stop, data[7:0], start}

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1'b1; tx_busy <= 0;
            baud_cnt <= 0; bit_idx <= 0;
        end else if (!tx_busy && tx_start) begin
            shift_reg <= {1'b1, tx_data, 1'b0};  // stop, data, start
            tx_busy   <= 1'b1;
            baud_cnt  <= 0;
            bit_idx   <= 0;
        end else if (tx_busy) begin
            if (baud_cnt == BIT_PERIOD - 1) begin
                baud_cnt <= 0;
                tx       <= shift_reg[bit_idx];
                bit_idx  <= bit_idx + 1'b1;
                if (bit_idx == 9) begin
                    tx_busy <= 1'b0;
                    tx      <= 1'b1;
                end
            end else begin
                baud_cnt <= baud_cnt + 1'b1;
            end
        end
    end
endmodule
