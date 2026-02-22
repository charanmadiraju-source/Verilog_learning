// 4-Bit SIPO (Serial-In Parallel-Out) Shift Register
module sipo_shift_register (
    input  clk,
    input  rst_n,
    input  si,
    output [3:0] po   // parallel output
);
    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 4'b0;
        else
            shift_reg <= {shift_reg[2:0], si};
    end

    assign po = shift_reg;
endmodule
