// Experiment 126: I2C Master (Simplified)
// Generates START, 7-bit address + R/W, ACK, 8-bit data, ACK, STOP.
// Inputs : clk, rst, start_xfer, addr[6:0], wr_data[7:0]
// Outputs: sda_out, scl_out, done
module i2c_master_simple (
    input        clk, rst, start_xfer,
    input  [6:0] addr,
    input  [7:0] wr_data,
    output reg   sda_out, scl_out, done, ack_received
);
    localparam IDLE=0,START=1,ADDR=2,ACK1=3,DATA=4,ACK2=5,STOP=6;
    reg [2:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE;scl_out<=1;sda_out<=1;done<=0;bit_cnt<=0;ack_received<=0; end
        else case (state)
            IDLE: begin scl_out<=1;sda_out<=1;done<=0;
                if(start_xfer) begin sda_out<=0; state<=START; end
            end
            START: begin
                scl_out<=0; shift_reg<={addr,1'b0}; bit_cnt<=8; state<=ADDR;
            end
            ADDR: begin
                sda_out<=shift_reg[7]; shift_reg<={shift_reg[6:0],1'b0};
                scl_out<=~scl_out;
                if(scl_out==0 && bit_cnt==1) state<=ACK1;
                else if(scl_out==0) bit_cnt<=bit_cnt-1;
            end
            ACK1: begin scl_out<=~scl_out; if(scl_out) begin
                sda_out<=1; shift_reg<=wr_data; bit_cnt<=8; state<=DATA; end end
            DATA: begin
                sda_out<=shift_reg[7]; shift_reg<={shift_reg[6:0],1'b0};
                scl_out<=~scl_out;
                if(scl_out==0 && bit_cnt==1) state<=ACK2;
                else if(scl_out==0) bit_cnt<=bit_cnt-1;
            end
            ACK2: begin scl_out<=~scl_out; if(scl_out) begin ack_received<=1; state<=STOP; end end
            STOP: begin scl_out<=1; sda_out<=1; done<=1; state<=IDLE; end
        endcase
    end
endmodule
