// Experiment 121: Minimal RISC CPU (4 instructions)
// Instructions: ADD, SUB, AND, OR (register-register)
// 4 registers (R0-R3), 4-entry instruction memory.
// Encoding: [7:6]=opcode, [5:4]=rd, [3:2]=rs1, [1:0]=rs2
// Inputs : clk, rst
// Outputs: pc[1:0], alu_out[7:0]
module risc4 (
    input  clk, rst,
    output reg [1:0] pc,
    output reg [7:0] alu_out
);
    reg [7:0] imem [0:3];
    reg [7:0] regfile [0:3];
    integer i;
    initial begin
        // Initialize registers
        regfile[0]=8'd10; regfile[1]=8'd20; regfile[2]=8'd5; regfile[3]=8'd0;
        // Program: ADD R3=R0+R1, SUB R3=R3-R2, AND R3=R3&R1, OR R3=R3|R2
        imem[0]=8'b00_11_00_01; // ADD R3=R0+R1
        imem[1]=8'b01_11_11_10; // SUB R3=R3-R2
        imem[2]=8'b10_11_11_01; // AND R3=R3&R1
        imem[3]=8'b11_11_11_10; // OR  R3=R3|R2
    end
    wire [7:0] instr  = imem[pc];
    wire [1:0] op     = instr[7:6];
    wire [1:0] rd_idx = instr[5:4];
    wire [1:0] rs1    = instr[3:2];
    wire [1:0] rs2    = instr[1:0];
    always @(posedge clk or posedge rst) begin
        if (rst) begin pc<=0; alu_out<=0; for(i=0;i<4;i=i+1) regfile[i]<=0;
            regfile[0]<=8'd10; regfile[1]<=8'd20; regfile[2]<=8'd5;
        end else begin
            case (op)
                2'b00: regfile[rd_idx] <= regfile[rs1] + regfile[rs2];
                2'b01: regfile[rd_idx] <= regfile[rs1] - regfile[rs2];
                2'b10: regfile[rd_idx] <= regfile[rs1] & regfile[rs2];
                2'b11: regfile[rd_idx] <= regfile[rs1] | regfile[rs2];
            endcase
            alu_out <= regfile[rd_idx];
            pc <= (pc == 2'd3) ? 2'd0 : pc + 1;
        end
    end
endmodule
