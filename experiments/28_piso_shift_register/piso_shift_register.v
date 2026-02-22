// 4-Bit PISO (Parallel-In Serial-Out) Shift Register
// load=1: load parallel data; load=0: shift out MSB first
module piso_shift_register (
    input        clk,
    input        rst_n,
    input        load,
    input  [3:0] pi,
    output       so
);
    reg [3:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= 4'b0;
        else if (load)
            shift_reg <= pi;
        else
            shift_reg <= {shift_reg[2:0], 1'b0};
    end

    assign so = shift_reg[3];
endmodule
