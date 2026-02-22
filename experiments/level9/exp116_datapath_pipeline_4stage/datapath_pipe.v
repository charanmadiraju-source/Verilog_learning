// Experiment 116: Simple 4-Stage Datapath Pipeline
// IF: Fetch (increment PC), ID: Decode (register read), EX: Execute (ALU), WB: Write-back.
// Simplified: each stage register holds operation and operands.
// Inputs : clk, rst, opcode[1:0], rs_data[7:0], rt_data[7:0]
// Outputs: wb_result[7:0], wb_valid
module datapath_pipe (
    input        clk, rst,
    input  [1:0] opcode,
    input  [7:0] rs_data, rt_data,
    output reg [7:0] wb_result,
    output reg       wb_valid
);
    // Pipeline registers
    reg [1:0] id_op, ex_op;
    reg [7:0] id_rs, id_rt, ex_rs, ex_rt, ex_result;
    // Stage 1->2: IF->ID
    always @(posedge clk or posedge rst) begin
        if (rst) begin id_op<=0; id_rs<=0; id_rt<=0; end
        else begin id_op<=opcode; id_rs<=rs_data; id_rt<=rt_data; end
    end
    // Stage 2->3: ID->EX
    always @(posedge clk or posedge rst) begin
        if (rst) begin ex_op<=0; ex_rs<=0; ex_rt<=0; end
        else begin ex_op<=id_op; ex_rs<=id_rs; ex_rt<=id_rt; end
    end
    // Stage 3: EX
    always @(posedge clk or posedge rst) begin
        if (rst) begin ex_result<=0; end
        else case (ex_op)
            2'b00: ex_result <= ex_rs + ex_rt;
            2'b01: ex_result <= ex_rs - ex_rt;
            2'b10: ex_result <= ex_rs & ex_rt;
            2'b11: ex_result <= ex_rs | ex_rt;
        endcase
    end
    // Stage 4: WB
    always @(posedge clk or posedge rst) begin
        if (rst) begin wb_result<=0; wb_valid<=0; end
        else begin wb_result<=ex_result; wb_valid<=1; end
    end
endmodule
