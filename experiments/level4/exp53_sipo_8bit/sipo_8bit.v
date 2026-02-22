// Experiment 53: 8-bit Shift Register (Serial In, Parallel Out - SIPO)
// Shifts serial input; all 8 bits available as parallel output.
// Inputs : clk, rst, sin
// Output : parallel_out[7:0]
module sipo_8bit (
    input        clk, rst, sin,
    output [7:0] parallel_out
);
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if (rst) shift_reg <= 8'b0;
        else     shift_reg <= {shift_reg[6:0], sin};
    end
    assign parallel_out = shift_reg;
endmodule
