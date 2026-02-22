// Experiment 120: Out-of-Order Issue Unit (2-entry Reservation Station)
// Holds instructions waiting for operands. Issues when both operands ready.
// Inputs : clk, rst, dispatch (add entry), rs_valid[1:0], rt_valid[1:0]
//          opcode[1:0], rs_data[7:0], rt_data[7:0]
// Outputs: issue (instruction issued), issue_opcode[1:0], issue_rs[7:0], issue_rt[7:0]
module ooo_issue (
    input        clk, rst, dispatch,
    input        rs_valid, rt_valid,
    input  [1:0] opcode,
    input  [7:0] rs_data, rt_data,
    output reg   issue,
    output reg [1:0] issue_opcode,
    output reg [7:0] issue_rs, issue_rt
);
    reg [1:0] op_q;
    reg [7:0] rs_q, rt_q;
    reg       rsv, rtv, occupied;
    always @(posedge clk or posedge rst) begin
        if (rst) begin occupied<=0; issue<=0; end
        else begin
            issue <= 0;
            if (dispatch && !occupied) begin
                op_q<=opcode; rs_q<=rs_data; rt_q<=rt_data;
                rsv<=rs_valid; rtv<=rt_valid; occupied<=1;
            end
            if (occupied && rsv && rtv) begin
                issue<=1; issue_opcode<=op_q; issue_rs<=rs_q; issue_rt<=rt_q;
                occupied<=0;
            end
        end
    end
endmodule
