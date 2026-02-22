// Experiment 155: SPI with DMA Transfer
// DMA pre-loads TX FIFO and reads RX FIFO automatically.
module spi_dma #(parameter N=4)(
    input        clk, rst, dma_start,
    input  [7:0] dma_mem [0:N-1],
    output reg [7:0] rx_mem [0:N-1],
    output reg done
);
    reg [7:0] tx_shift, rx_shift; reg [3:0] bit_cnt; reg [2:0] byte_cnt;
    reg sclk, busy;
    always @(posedge clk or posedge rst) begin
        if(rst)begin done<=0;busy<=0;sclk<=0;byte_cnt<=0;bit_cnt<=0;end
        else begin
            done<=0;
            if(!busy&&dma_start)begin busy<=1;byte_cnt<=0;bit_cnt<=0;tx_shift<=dma_mem[0];end
            else if(busy)begin
                sclk<=~sclk;
                if(!sclk)begin rx_shift<={rx_shift[6:0],tx_shift[7]};tx_shift<={tx_shift[6:0],1'b0};end
                else begin bit_cnt<=bit_cnt+1;
                    if(bit_cnt==7)begin rx_mem[byte_cnt]<=rx_shift;bit_cnt<=0;
                        if(byte_cnt==N-1)begin done<=1;busy<=0;end
                        else begin byte_cnt<=byte_cnt+1;tx_shift<=dma_mem[byte_cnt+1];end
                    end
                end
            end
        end
    end
endmodule
