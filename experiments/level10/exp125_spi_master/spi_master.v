// Experiment 125: SPI Master Controller
// Mode 0 (CPOL=0, CPHA=0). Shifts 8 bits MSB first.
// Inputs : clk, rst, start, mosi_data[7:0], miso
// Outputs: mosi, sclk, cs_n, rx_data[7:0], done
module spi_master (
    input        clk, rst, start, miso,
    input  [7:0] mosi_data,
    output reg   mosi, sclk, cs_n, done,
    output reg [7:0] rx_data
);
    reg [3:0] bit_cnt;
    reg [7:0] shift_out, shift_in;
    reg       busy;
    always @(posedge clk or posedge rst) begin
        if (rst) begin cs_n<=1;sclk<=0;mosi<=0;done<=0;busy<=0;bit_cnt<=0; end
        else begin
            done <= 0;
            if (start && !busy) begin
                shift_out <= mosi_data; cs_n<=0; busy<=1; bit_cnt<=0;
            end else if (busy) begin
                if (!sclk) begin // rising edge coming
                    mosi <= shift_out[7];
                    shift_out <= {shift_out[6:0],1'b0};
                    sclk <= 1;
                end else begin // falling edge coming
                    shift_in <= {shift_in[6:0], miso};
                    sclk <= 0;
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 7) begin
                        cs_n<=1; busy<=0; done<=1; rx_data<=shift_in;
                    end
                end
            end
        end
    end
endmodule
