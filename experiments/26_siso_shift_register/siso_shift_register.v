// 4-Bit SISO (Serial-In Serial-Out) Shift Register
module siso_shift_register (
    input  clk,
    input  rst_n,
    input  si,       // serial input
    output so        // serial output (MSB shifted out)
);
    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 4'b0;
        else
            shift_reg <= {shift_reg[2:0], si};
    end

    assign so = shift_reg[3];
endmodule
