// Experiment 154: UART with Interrupt
// TX complete and RX data ready generate interrupts.
// IRQ pending register: [0]=rx_ready, [1]=tx_complete
// Inputs : clk, rst, baud_div[3:0], tx_data[7:0], tx_start, irq_clear[1:0], rx_serial
// Outputs: tx_serial, tx_busy, rx_data[7:0], rx_valid, irq
module uart_irq #(parameter BAUD_DIV=4) (
    input        clk, rst,
    input  [7:0] tx_data,
    input        tx_start, rx_serial,
    input  [1:0] irq_clear,
    output       tx_serial, tx_busy,
    output reg [7:0] rx_data,
    output reg       rx_valid,
    output reg       irq,
    output reg [1:0] irq_pending
);
    // TX
    reg [7:0] tx_shift; reg [3:0] tx_cnt; reg [2:0] tx_bd; reg tx_busy_r, tx_out;
    assign tx_serial=tx_out; assign tx_busy=tx_busy_r;
    always @(posedge clk or posedge rst) begin
        if(rst)begin tx_busy_r<=0;tx_out<=1;tx_cnt<=0;tx_bd<=0;end
        else if(!tx_busy_r&&tx_start)begin tx_shift<=tx_data;tx_busy_r<=1;tx_cnt<=0;tx_bd<=0;tx_out<=0;end
        else if(tx_busy_r)begin
            if(tx_bd==BAUD_DIV-1)begin tx_bd<=0;
                if(tx_cnt<8)begin tx_out<=tx_shift[0];tx_shift>>=1;tx_cnt<=tx_cnt+1;end
                else begin tx_out<=1;tx_busy_r<=0; end
            end else tx_bd<=tx_bd+1;
        end
    end
    // RX
    reg [7:0] rx_shift; reg [3:0] rx_cnt; reg [2:0] rx_bd; reg rx_active; reg [7:0] rx_data_r;
    always @(posedge clk or posedge rst) begin
        if(rst)begin rx_active<=0;rx_valid<=0;end
        else begin
            rx_valid<=0;
            if(!rx_active&&!rx_serial)begin rx_active<=1;rx_bd<=BAUD_DIV/2;rx_cnt<=0;end
            else if(rx_active)begin
                if(rx_bd==BAUD_DIV-1)begin rx_bd<=0;
                    if(rx_cnt<8)begin rx_shift<={rx_serial,rx_shift[7:1]};rx_cnt<=rx_cnt+1;end
                    else begin rx_data<=rx_shift;rx_valid<=1;rx_active<=0;end
                end else rx_bd<=rx_bd+1;
            end
        end
    end
    // IRQ
    always @(posedge clk or posedge rst) begin
        if(rst)begin irq_pending<=0;irq<=0;end
        else begin
            irq_pending <= (irq_pending & ~irq_clear) | {(!tx_busy_r && tx_cnt==4'd8), rx_valid};
            irq <= |irq_pending;
        end
    end
endmodule
