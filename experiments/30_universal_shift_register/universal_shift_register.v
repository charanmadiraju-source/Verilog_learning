// Universal 4-Bit Shift Register
// mode[1:0]: 00=hold, 01=shift-right, 10=shift-left, 11=parallel load
module universal_shift_register (
    input        clk,
    input        rst_n,
    input  [1:0] mode,
    input        si_right,  // serial input for right shift
    input        si_left,   // serial input for left shift
    input  [3:0] pi,        // parallel input
    output reg [3:0] po
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            po <= 4'b0;
        else
            case (mode)
                2'b00: po <= po;                          // hold
                2'b01: po <= {si_right, po[3:1]};         // shift right
                2'b10: po <= {po[2:0], si_left};          // shift left
                2'b11: po <= pi;                          // parallel load
            endcase
    end
endmodule
