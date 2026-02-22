// Experiment 155: SPI with DMA Transfer
// DMA pre-loads TX FIFO and reads RX FIFO automatically.
module spi_dma #(parameter N=4)(
    input        clk, rst, dma_start,
    input  [N*8-1:0] dma_mem,
    output [N*8-1:0] rx_mem,
    output reg done
);
    reg [7:0] tx_shift, rx_shift; reg [3:0] bit_cnt; reg [2:0] byte_cnt;
    reg sclk, busy;
    reg [7:0] rx_arr [0:N-1];
    genvar gi;
    generate for(gi=0; gi<N; gi=gi+1) begin: gen_rx
        assign rx_mem[gi*8 +: 8] = rx_arr[gi];
    end endgenerate
    always @(posedge clk or posedge rst) begin
        if(rst)begin done<=0;busy<=0;sclk<=0;byte_cnt<=0;bit_cnt<=0;end
        else begin
            done<=0;
            if(!busy&&dma_start)begin busy<=1;byte_cnt<=0;bit_cnt<=0;tx_shift<=dma_mem[0 +: 8];end
            else if(busy)begin
                sclk<=~sclk;
                if(!sclk)begin rx_shift<={rx_shift[6:0],tx_shift[7]};tx_shift<={tx_shift[6:0],1'b0};end
                else begin bit_cnt<=bit_cnt+1;
                    if(bit_cnt==7)begin rx_arr[byte_cnt]<=rx_shift;bit_cnt<=0;
                        if(byte_cnt==N-1)begin done<=1;busy<=0;end
                        else begin byte_cnt<=byte_cnt+1;tx_shift<=dma_mem[(byte_cnt+1)*8 +: 8];end
                    end
                end
            end
        end
    end
endmodule
