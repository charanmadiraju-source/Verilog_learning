// Experiment 51: 8-bit Shift Register (Serial In, Serial Out - SISO)
// Data shifts in one bit per clock; serial out is the MSB leaving.
// Inputs : clk, rst, sin
// Output : sout (MSB shifted out)
module siso_8bit (
    input  clk, rst, sin,
    output sout
);
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if (rst) shift_reg <= 8'b0;
        else     shift_reg <= {shift_reg[6:0], sin};
    end
    assign sout = shift_reg[7];
endmodule
