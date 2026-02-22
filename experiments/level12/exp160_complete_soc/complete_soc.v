// Experiment 160: Complete SoC (CPU + Memory + GPIO + UART + Timer)
// Simplified SoC integrating key components connected via an internal bus.
// Bus address map: 0x00-0x3F=memory, 0x40=GPIO, 0x50=UART_TX, 0x60=TIMER
module complete_soc(
    input clk,rst,
    input uart_rx,
    output uart_tx,
    output[7:0]gpio_out,
    output[3:0]leds,
    output irq_out
);
    // Internal bus signals
    reg[7:0]bus_addr,bus_wdata; reg bus_we;
    wire[7:0]bus_rdata;
    // Memory (64 bytes)
    reg[7:0]mem[0:63];
    // GPIO output register
    reg[7:0]gpio_reg;
    // Timer count
    reg[7:0]timer_cnt;
    // UART TX shift
    reg[7:0]uart_tx_data; reg uart_tx_start;
    // Simple CPU: execute stored program
    reg[5:0]pc;
    reg[7:0]acc;
    reg[2:0]cpu_state;
    reg irq_r;
    initial begin
        // Minimal program: load 0xA5 to acc, store to GPIO(0x40), halt
        mem[0]=8'h01; mem[1]=8'hA5; // LDA #0xA5
        mem[2]=8'h02; mem[3]=8'h40; // STA 0x40 (GPIO)
        mem[4]=8'h00;               // HALT
    end
    always@(posedge clk or posedge rst)begin
        if(rst)begin pc<=0;acc<=0;cpu_state<=0;bus_we<=0;gpio_reg<=0;timer_cnt<=0;irq_r<=0;end
        else begin
            bus_we<=0;
            timer_cnt<=timer_cnt+1;
            if(timer_cnt==8'hFF)irq_r<=1; else irq_r<=0;
            case(cpu_state)
                0:begin // FETCH
                    if(mem[pc]==8'h00)cpu_state<=5; // HALT
                    else if(mem[pc]==8'h01)begin acc<=mem[pc+1];pc<=pc+2;end // LDA
                    else if(mem[pc]==8'h02)begin bus_addr<=mem[pc+1];bus_wdata<=acc;bus_we<=1;pc<=pc+2;end // STA
                    else pc<=pc+1;
                end
                5:; // HALT
            endcase
            if(bus_we)begin
                if(bus_addr[7:6]==2'b00)mem[bus_addr[5:0]]<=bus_wdata;
                else if(bus_addr==8'h40)gpio_reg<=bus_wdata;
            end
        end
    end
    assign gpio_out=gpio_reg;
    assign leds=timer_cnt[7:4];
    assign uart_tx=1'b1; // idle
    assign irq_out=irq_r;
endmodule
