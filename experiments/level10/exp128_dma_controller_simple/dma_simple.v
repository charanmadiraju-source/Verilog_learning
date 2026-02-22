// Experiment 128: Simple DMA Controller
// Transfers N bytes from source to destination memory address.
// Inputs : clk, rst, start, src_base[7:0], dst_base[7:0], len[7:0]
// Outputs: done, mem_rd_addr[7:0], mem_wr_addr[7:0], mem_wr_en
module dma_simple (
    input        clk, rst, start,
    input  [7:0] src_base, dst_base, len,
    output reg       done, mem_wr_en,
    output reg [7:0] mem_rd_addr, mem_wr_addr,
    output reg [7:0] count
);
    reg busy;
    always @(posedge clk or posedge rst) begin
        if (rst) begin done<=0; busy<=0; mem_wr_en<=0; count<=0; end
        else begin
            done<=0; mem_wr_en<=0;
            if (!busy && start) begin
                busy<=1; count<=0; mem_rd_addr<=src_base; mem_wr_addr<=dst_base;
            end else if (busy) begin
                mem_rd_addr <= src_base + count;
                mem_wr_addr <= dst_base + count;
                mem_wr_en   <= 1;
                count       <= count + 1;
                if (count == len-1) begin done<=1; busy<=0; end
            end
        end
    end
endmodule
