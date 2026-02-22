// Experiment 129: Interrupt Controller (4 priority levels)
// Arbitrates 4 interrupt requests; higher bit = higher priority.
// Inputs : clk, rst, irq[3:0], ack
// Outputs: intr, irq_id[1:0]
module irq_ctrl (
    input        clk, rst, ack,
    input  [3:0] irq,
    output reg   intr,
    output reg [1:0] irq_id
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin intr<=0; irq_id<=0; end
        else if (ack) begin intr<=0; end
        else if (irq[3]) begin intr<=1; irq_id<=2'd3; end
        else if (irq[2]) begin intr<=1; irq_id<=2'd2; end
        else if (irq[1]) begin intr<=1; irq_id<=2'd1; end
        else if (irq[0]) begin intr<=1; irq_id<=2'd0; end
        else intr<=0;
    end
endmodule
