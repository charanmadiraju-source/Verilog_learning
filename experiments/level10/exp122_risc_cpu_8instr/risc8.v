// Experiment 122: RISC CPU with 8 instructions
// Instructions: ADD, SUB, AND, OR, XOR, SHL, SHR, NOP
// 8 registers (R0-R7), 11-bit instruction: [10:8]=opcode, [7:5]=rd, [4:2]=rs1, [1:0]=rs2
module risc8 (
    input  clk, rst,
    output reg [3:0] pc,
    output reg [7:0] result
);
    reg [10:0] imem [0:15];
    reg [7:0]  regfile [0:7];
    reg [7:0]  alu_out;
    integer i;
    initial begin
        for(i=0;i<8;i=i+1) regfile[i]=0;
        regfile[0]=8'd10; regfile[1]=8'd3; regfile[2]=8'd2;
        imem[0] = 11'd97;   // ADD R3=R0+R1  (op=000,rd=011,rs1=000,rs2=01)
        imem[1] = 11'd398;  // SUB R4=R3-R2  (op=001,rd=100,rs1=011,rs2=10)
        imem[2] = 11'd673;  // AND R5=R0&R1  (op=010,rd=101,rs1=000,rs2=01)
        imem[3] = 11'd961;  // OR  R6=R0|R1  (op=011,rd=110,rs1=000,rs2=01)
        for(i=4;i<16;i=i+1) imem[i]=0;
    end
    wire [10:0] instr  = imem[pc];
    wire [2:0]  op     = instr[10:8];
    wire [2:0]  rd_idx = instr[7:5];
    wire [2:0]  rs1    = instr[4:2];
    wire [1:0]  rs2    = instr[1:0];
    always @(*) begin
        case (op)
            3'b000: alu_out = regfile[rs1] + regfile[rs2];
            3'b001: alu_out = regfile[rs1] - regfile[rs2];
            3'b010: alu_out = regfile[rs1] & regfile[rs2];
            3'b011: alu_out = regfile[rs1] | regfile[rs2];
            3'b100: alu_out = regfile[rs1] ^ regfile[rs2];
            3'b101: alu_out = regfile[rs1] << 1;
            3'b110: alu_out = regfile[rs1] >> 1;
            default: alu_out = 8'b0;
        endcase
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin pc<=0; result<=0;
            for(i=0;i<8;i=i+1) regfile[i]<=0;
            regfile[0]<=8'd10; regfile[1]<=8'd3; regfile[2]<=8'd2;
        end else begin
            regfile[rd_idx] <= alu_out;
            result          <= alu_out;
            pc              <= pc + 1;
        end
    end
endmodule
