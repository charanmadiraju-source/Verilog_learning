// Experiment 139: Wishbone B4 Slave (4 registers)
// Classic handshake: STB + CYC -> ACK
// Inputs : wb_clk, wb_rst, wb_cyc, wb_stb, wb_we, wb_adr[3:0], wb_dat_i[7:0]
// Outputs: wb_ack, wb_dat_o[7:0]
module wb_slave (
    input        wb_clk, wb_rst,
    input        wb_cyc, wb_stb, wb_we,
    input  [3:0] wb_adr,
    input  [7:0] wb_dat_i,
    output reg   wb_ack,
    output reg [7:0] wb_dat_o
);
    reg [7:0] regs [0:3];
    integer i;
    always @(posedge wb_clk or posedge wb_rst) begin
        if (wb_rst) begin wb_ack<=0; wb_dat_o<=0; for(i=0;i<4;i=i+1) regs[i]<=0; end
        else begin
            wb_ack <= 0;
            if (wb_cyc && wb_stb && !wb_ack) begin
                wb_ack <= 1;
                if (wb_we) regs[wb_adr[1:0]] <= wb_dat_i;
                else wb_dat_o <= regs[wb_adr[1:0]];
            end
        end
    end
endmodule
