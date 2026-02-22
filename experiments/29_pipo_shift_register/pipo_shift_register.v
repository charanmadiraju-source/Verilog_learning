// 4-Bit PIPO (Parallel-In Parallel-Out) Shift Register
module pipo_shift_register (
    input        clk,
    input        rst_n,
    input        load,
    input  [3:0] pi,
    output reg [3:0] po
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            po <= 4'b0;
        else if (load)
            po <= pi;
    end
endmodule
