// Experiment 127: UART with RX FIFO (Top Level Integration)
// Instantiates UART TX, UART RX, and a synchronous FIFO.
// Loopback: TX drives RX, received bytes stored in FIFO.
// Parameters: BAUD_DIV=4 (for fast simulation), DEPTH=8
module uart_fifo_top #(
    parameter BAUD_DIV = 4,
    parameter DEPTH    = 8
)(
    input        clk, rst,
    input  [7:0] tx_data,
    input        tx_start,
    output       tx_busy,
    output [7:0] rx_fifo_out,
    output       rx_fifo_empty,
    input        rx_fifo_rd
);
    wire       tx_serial;
    wire [7:0] rx_byte;
    wire       rx_valid;
    // Simple UART TX
    reg [7:0]  tx_shift;
    reg [3:0]  tx_bit_cnt;
    reg [$clog2(BAUD_DIV)-1:0] tx_baud_cnt;
    reg        tx_busy_r;
    assign tx_busy = tx_busy_r;
    reg tx_out;
    assign tx_serial = tx_out;
    always @(posedge clk or posedge rst) begin
        if (rst) begin tx_busy_r<=0; tx_out<=1; tx_bit_cnt<=0; tx_baud_cnt<=0; end
        else if (!tx_busy_r && tx_start) begin
            tx_shift<=tx_data; tx_busy_r<=1; tx_bit_cnt<=0; tx_baud_cnt<=0; tx_out<=0;
        end else if (tx_busy_r) begin
            if (tx_baud_cnt == BAUD_DIV-1) begin
                tx_baud_cnt<=0;
                if (tx_bit_cnt < 8) begin tx_out<=tx_shift[0]; tx_shift>>=1; tx_bit_cnt<=tx_bit_cnt+1; end
                else begin tx_out<=1; tx_busy_r<=0; end
            end else tx_baud_cnt<=tx_baud_cnt+1;
        end
    end
    // Simple UART RX
    reg [7:0]  rx_shift;
    reg [3:0]  rx_bit_cnt;
    reg [$clog2(BAUD_DIV)-1:0] rx_baud_cnt;
    reg        rx_active;
    reg        rx_valid_r;
    reg [7:0]  rx_byte_r;
    assign rx_byte  = rx_byte_r;
    assign rx_valid = rx_valid_r;
    always @(posedge clk or posedge rst) begin
        if (rst) begin rx_active<=0; rx_valid_r<=0; rx_bit_cnt<=0; rx_baud_cnt<=0; end
        else begin
            rx_valid_r<=0;
            if (!rx_active && !tx_serial) begin rx_active<=1; rx_baud_cnt<=BAUD_DIV/2; rx_bit_cnt<=0; end
            else if (rx_active) begin
                if (rx_baud_cnt==BAUD_DIV-1) begin
                    rx_baud_cnt<=0;
                    if (rx_bit_cnt<8) begin rx_shift<={tx_serial,rx_shift[7:1]}; rx_bit_cnt<=rx_bit_cnt+1; end
                    else begin rx_byte_r<=rx_shift; rx_valid_r<=1; rx_active<=0; end
                end else rx_baud_cnt<=rx_baud_cnt+1;
            end
        end
    end
    // Sync FIFO
    reg [7:0]  fifo_mem [0:DEPTH-1];
    reg [2:0]  wr_ptr, rd_ptr;
    reg [3:0]  count;
    assign rx_fifo_empty = (count==0);
    assign rx_fifo_out   = fifo_mem[rd_ptr];
    always @(posedge clk or posedge rst) begin
        if (rst) begin wr_ptr<=0; rd_ptr<=0; count<=0; end
        else begin
            if (rx_valid && count<DEPTH) begin fifo_mem[wr_ptr]<=rx_byte; wr_ptr<=(wr_ptr+1)%DEPTH; count<=count+1; end
            if (rx_fifo_rd && count>0) begin rd_ptr<=(rd_ptr+1)%DEPTH; count<=count-1; end
        end
    end
endmodule
