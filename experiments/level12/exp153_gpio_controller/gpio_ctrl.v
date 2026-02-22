// Experiment 153: GPIO Controller (8-bit, with direction and interrupt)
// Inputs : clk, rst, we (write enable), dir_we (direction write), addr[1:0]
//          wr_data[7:0], gpio_in[7:0]
// Outputs: gpio_out[7:0], rd_data[7:0], irq
// Registers: 0=output,1=direction(1=out),2=interrupt_mask,3=interrupt_status
module gpio_ctrl (
    input        clk, rst, we, dir_we,
    input  [1:0] addr,
    input  [7:0] wr_data, gpio_in,
    output reg [7:0] gpio_out, rd_data,
    output reg        irq
);
    reg [7:0] out_reg, dir_reg, irq_mask, irq_status, gpio_in_prev;
    assign gpio_out = (dir_reg) ? out_reg : 8'b0; // simplified
    always @(posedge clk or posedge rst) begin
        if (rst) begin out_reg<=0;dir_reg<=0;irq_mask<=0;irq_status<=0;gpio_in_prev<=0;irq<=0; end
        else begin
            // Detect input changes for interrupt
            irq_status <= irq_status | ((gpio_in ^ gpio_in_prev) & irq_mask);
            gpio_in_prev <= gpio_in;
            irq <= (irq_status != 0);
            // Register write
            if (we) case (addr)
                2'd0: out_reg   <= wr_data;
                2'd1: dir_reg   <= wr_data;
                2'd2: irq_mask  <= wr_data;
                2'd3: irq_status<= irq_status & ~wr_data; // write 1 to clear
            endcase
            // Register read
            case (addr)
                2'd0: rd_data <= out_reg;
                2'd1: rd_data <= dir_reg;
                2'd2: rd_data <= irq_mask;
                2'd3: rd_data <= irq_status;
            endcase
        end
    end
endmodule
