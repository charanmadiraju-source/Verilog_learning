// Experiment 83: UART Transmitter (Start, 8-data, Stop)
// CLK_DIV sets baud rate divisor (small for simulation).
// Inputs : clk, rst, tx_start, tx_data[7:0]
// Outputs: tx, tx_busy
module uart_tx #(parameter CLK_DIV=4) (
    input        clk, rst, tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output       tx_busy
);
    localparam IDLE=2'd0, START=2'd1, DATA=2'd2, STOP=2'd3;
    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;
    reg [$clog2(CLK_DIV)-1:0] baud_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE; tx<=1; bit_cnt<=0; baud_cnt<=0; end
        else case (state)
            IDLE: begin
                tx<=1;
                if (tx_start) begin shift_reg<=tx_data; state<=START; baud_cnt<=0; end
            end
            START: begin
                tx<=0;
                if (baud_cnt==CLK_DIV-1) begin baud_cnt<=0; bit_cnt<=0; state<=DATA; end
                else baud_cnt<=baud_cnt+1;
            end
            DATA: begin
                tx<=shift_reg[0];
                if (baud_cnt==CLK_DIV-1) begin
                    baud_cnt<=0; shift_reg<={1'b0,shift_reg[7:1]};
                    if (bit_cnt==7) state<=STOP; else bit_cnt<=bit_cnt+1;
                end else baud_cnt<=baud_cnt+1;
            end
            STOP: begin
                tx<=1;
                if (baud_cnt==CLK_DIV-1) begin baud_cnt<=0; state<=IDLE; end
                else baud_cnt<=baud_cnt+1;
            end
        endcase
    end
    assign tx_busy = (state != IDLE);
endmodule
