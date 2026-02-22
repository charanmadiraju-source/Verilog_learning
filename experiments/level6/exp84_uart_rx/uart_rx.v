// Experiment 84: UART Receiver
// Oversampling (CLK_DIV ticks per bit); samples at center of each bit.
// Inputs : clk, rst, rx
// Outputs: rx_data[7:0], rx_done
module uart_rx #(parameter CLK_DIV=4) (
    input        clk, rst, rx,
    output reg [7:0] rx_data,
    output reg       rx_done
);
    localparam IDLE=2'd0, START=2'd1, DATA=2'd2, STOP=2'd3;
    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [$clog2(CLK_DIV)-1:0] baud_cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE; rx_done<=0; rx_data<=0; baud_cnt<=0; bit_cnt<=0; end
        else begin
            rx_done<=0;
            case (state)
                IDLE: if(!rx) begin state<=START; baud_cnt<=0; end
                START: begin
                    if (baud_cnt == CLK_DIV/2 - 1) begin
                        baud_cnt<=0; bit_cnt<=0; state<=DATA;
                    end else baud_cnt<=baud_cnt+1;
                end
                DATA: begin
                    if (baud_cnt==CLK_DIV-1) begin
                        baud_cnt<=0;
                        rx_data<={rx, rx_data[7:1]};
                        if (bit_cnt==7) state<=STOP; else bit_cnt<=bit_cnt+1;
                    end else baud_cnt<=baud_cnt+1;
                end
                STOP: begin
                    if (baud_cnt==CLK_DIV-1) begin
                        baud_cnt<=0; rx_done<=1; state<=IDLE;
                    end else baud_cnt<=baud_cnt+1;
                end
            endcase
        end
    end
endmodule
