// Experiment 85: Simple SPI Master FSM
// Shifts out tx_data MSB first on MOSI, captures MISO into rx_data.
// CPOL=0, CPHA=0: data sampled on rising edge of sclk.
// Inputs : clk, rst, start, miso, tx_data[7:0]
// Outputs: sclk, mosi, cs_n, rx_data[7:0], done
module spi_master_fsm (
    input        clk, rst, start, miso,
    input  [7:0] tx_data,
    output reg   sclk, mosi, cs_n,
    output reg [7:0] rx_data,
    output reg   done
);
    localparam IDLE=2'd0, TRANSFER=2'd1, FINISH=2'd2;
    reg [1:0] state;
    reg [7:0] shift_tx;
    reg [2:0] bit_cnt;
    reg       clk_phase;

    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE; sclk<=0; mosi<=0; cs_n<=1; done<=0; end
        else begin
            done<=0;
            case(state)
                IDLE: begin
                    sclk<=0; cs_n<=1;
                    if(start) begin shift_tx<=tx_data; bit_cnt<=7; cs_n<=0; clk_phase<=0; state<=TRANSFER; end
                end
                TRANSFER: begin
                    clk_phase<=~clk_phase;
                    if(!clk_phase) begin // falling edge: shift out
                        sclk<=0;
                        mosi<=shift_tx[7];
                    end else begin // rising edge: sample in
                        sclk<=1;
                        rx_data<={rx_data[6:0],miso};
                        shift_tx<={shift_tx[6:0],1'b0};
                        if(bit_cnt==0) state<=FINISH;
                        else bit_cnt<=bit_cnt-1;
                    end
                end
                FINISH: begin sclk<=0; cs_n<=1; done<=1; state<=IDLE; end
            endcase
        end
    end
endmodule
