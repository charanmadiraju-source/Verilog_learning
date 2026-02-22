// Experiment 38: ALU with 4 Operations
// op: 00=add, 01=sub, 10=AND, 11=OR
// Inputs : a[3:0], b[3:0], op[1:0]
// Outputs: result[3:0], zero
module alu_4op (
    input  [3:0] a, b,
    input  [1:0] op,
    output reg [3:0] result,
    output zero
);
    always @(*) begin
        case (op)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a & b;
            2'b11: result = a | b;
            default: result = 4'b0;
        endcase
    end
    assign zero = (result == 4'b0);
endmodule
