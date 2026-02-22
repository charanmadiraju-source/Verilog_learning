// Experiment 152: SDRAM-Style Memory Controller (Simplified)
// Issues PRECHARGE, ACTIVATE, READ/WRITE commands based on request type.
// States: IDLE, ACTIVATE, READ_CMD, WRITE_CMD, PRECHARGE
module mem_ctrl (
    input        clk, rst,
    input        req, we,
    input  [7:0] addr,
    input  [7:0] wdata,
    output reg [7:0] rdata,
    output reg   ack,
    output reg [1:0] cmd // 0=NOP,1=ACT,2=RD,3=WR
);
    localparam IDLE=3'd0, ACTIVATE=3'd1, RD=3'd2, WR=3'd3, PCH=3'd4;
    reg [2:0] state;
    reg [7:0] mem [0:255];
    integer i;
    initial for(i=0;i<256;i=i+1) mem[i]=i[7:0];
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE; ack<=0; cmd<=0; end
        else case (state)
            IDLE: begin ack<=0; cmd<=0;
                if (req) begin cmd<=1; state<=ACTIVATE; end
            end
            ACTIVATE: begin
                if (we) begin cmd<=3; state<=WR; end
                else begin cmd<=2; state<=RD; end
            end
            RD: begin rdata<=mem[addr]; ack<=1; cmd<=0; state<=PCH; end
            WR: begin mem[addr]<=wdata; ack<=1; cmd<=0; state<=PCH; end
            PCH: begin ack<=0; state<=IDLE; end
        endcase
    end
endmodule
