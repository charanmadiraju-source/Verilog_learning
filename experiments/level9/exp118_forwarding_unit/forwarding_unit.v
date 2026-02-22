// Experiment 118: Forwarding Unit (Data Forwarding / Bypassing)
// Selects forwarded data from EX/MEM or MEM/WB for ALU inputs.
// forward_a: 00=from_register, 01=from_MEM/WB, 10=from_EX/MEM
// forward_b: same
module forwarding_unit (
    input  [4:0] ex_mem_rd, mem_wb_rd,
    input  [4:0] id_ex_rs, id_ex_rt,
    input        ex_mem_regwrite, mem_wb_regwrite,
    output reg [1:0] forward_a, forward_b
);
    always @(*) begin
        // Forward A
        if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs))
            forward_a = 2'b10;
        else if (mem_wb_regwrite && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs))
            forward_a = 2'b01;
        else forward_a = 2'b00;
        // Forward B
        if (ex_mem_regwrite && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rt))
            forward_b = 2'b10;
        else if (mem_wb_regwrite && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rt))
            forward_b = 2'b01;
        else forward_b = 2'b00;
    end
endmodule
