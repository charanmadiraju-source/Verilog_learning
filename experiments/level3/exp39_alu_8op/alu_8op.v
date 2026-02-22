// Experiment 39: ALU with 8 Operations
// op: 000=add, 001=sub, 010=AND, 011=OR, 100=XOR, 101=NOT a, 110=SHL, 111=SHR
// Inputs : a[7:0], b[7:0], op[2:0]
// Outputs: result[7:0], zero, carry, overflow
module alu_8op (
    input  [7:0] a, b,
    input  [2:0] op,
    output reg [7:0] result,
    output zero, carry, overflow
);
    reg c_out;
    wire signed [7:0] sa = a;
    wire signed [7:0] sb = b;
    always @(*) begin
        c_out = 1'b0;
        case (op)
            3'b000: {c_out, result} = {1'b0,a} + {1'b0,b};
            3'b001: {c_out, result} = {1'b0,a} - {1'b0,b};
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ~a;
            3'b110: result = a << 1;
            3'b111: result = a >> 1;
            default: result = 8'b0;
        endcase
    end
    assign zero     = (result == 8'b0);
    assign carry    = c_out;
    assign overflow = (op==3'b000) ? ((a[7]==b[7]) && (result[7]!=a[7])) :
                      (op==3'b001) ? ((a[7]!=b[7]) && (result[7]!=a[7])) : 1'b0;
endmodule
