// 32-Bit ALU
// op[2:0]: 000=ADD, 001=SUB, 010=AND, 011=OR, 100=XOR, 101=NOR, 110=SLT, 111=SLL
module alu_32bit (
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0]  op,
    output reg [31:0] result,
    output zero,        // asserted when result==0
    output overflow     // addition/subtraction overflow
);
    wire [32:0] add_result = {1'b0,a} + {1'b0,b};
    wire [32:0] sub_result = {1'b0,a} - {1'b0,b};

    assign zero     = (result == 32'b0);
    assign overflow = (op==3'b000) ? (add_result[32]) :
                      (op==3'b001) ? (sub_result[32]) : 1'b0;

    always @(*) begin
        case (op)
            3'b000: result = a + b;
            3'b001: result = a - b;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: result = ~(a | b);
            3'b110: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  // SLT
            3'b111: result = a << b[4:0];                                 // SLL
            default: result = 32'b0;
        endcase
    end
endmodule
