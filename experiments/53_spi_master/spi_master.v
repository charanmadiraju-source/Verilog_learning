// SPI Master (CPOL=0, CPHA=0)
// MOSI driven on falling edge; MISO sampled on rising edge
// Transmits and receives one byte per transaction
module spi_master #(
    parameter CLK_DIV = 4   // SPI clock = system clock / (2 * CLK_DIV)
)(
    input        clk,
    input        rst_n,
    input        start,
    input  [7:0] mosi_data,
    input        miso,
    output reg [7:0] miso_data,
    output reg       done,
    output reg       sclk,
    output reg       mosi,
    output reg       cs_n
);
    reg [$clog2(CLK_DIV)-1:0] div_cnt;
    reg [3:0]  bit_cnt;
    reg [7:0]  shift_out, shift_in;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sclk<=0; mosi<=0; cs_n<=1; done<=0; busy<=0;
            div_cnt<=0; bit_cnt<=0; shift_out<=0; shift_in<=0;
        end else begin
            done <= 0;
            if (!busy && start) begin
                cs_n      <= 0;
                shift_out <= mosi_data;
                mosi      <= mosi_data[7];  // drive MSB immediately before first rising edge
                bit_cnt   <= 0;
                div_cnt   <= 0;
                busy      <= 1;
                sclk      <= 0;
            end else if (busy) begin
                if (div_cnt == CLK_DIV - 1) begin
                    div_cnt <= 0;
                    sclk    <= ~sclk;
                    if (!sclk) begin
                        // About to go to rising edge: sample MISO
                        shift_in <= {shift_in[6:0], miso};
                        bit_cnt  <= bit_cnt + 1'b1;
                    end else begin
                        // About to go to falling edge: drive next MOSI bit (if not done)
                        if (bit_cnt == 8) begin
                            cs_n      <= 1;
                            mosi      <= 0;
                            busy      <= 0;
                            miso_data <= shift_in;  // all 8 bits already captured from rising edges
                            done      <= 1;
                        end else begin
                            shift_out <= {shift_out[6:0], 1'b0};
                            mosi      <= shift_out[6];  // next bit
                        end
                    end
                end else begin
                    div_cnt <= div_cnt + 1'b1;
                end
            end
        end
    end
endmodule
