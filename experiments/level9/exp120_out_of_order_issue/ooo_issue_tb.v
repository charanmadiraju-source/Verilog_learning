`timescale 1ns/1ps
module ooo_issue_tb;
    reg clk=0,rst,dispatch,rs_valid,rt_valid; reg [1:0] opcode; reg [7:0] rs_data,rt_data;
    wire issue; wire [1:0] issue_opcode; wire [7:0] issue_rs,issue_rt;
    always #5 clk=~clk;
    ooo_issue uut(.clk(clk),.rst(rst),.dispatch(dispatch),.rs_valid(rs_valid),.rt_valid(rt_valid),
                  .opcode(opcode),.rs_data(rs_data),.rt_data(rt_data),
                  .issue(issue),.issue_opcode(issue_opcode),.issue_rs(issue_rs),.issue_rt(issue_rt));
    integer errors=0;
    initial begin
        $dumpfile("ooo_issue.vcd"); $dumpvars(0,ooo_issue_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Dispatch with both operands ready
        dispatch=1;rs_valid=1;rt_valid=1;opcode=2'b00;rs_data=8'd5;rt_data=8'd3;
        @(posedge clk);#1; dispatch=0;
        @(posedge clk);#1;
        if(issue!==1||issue_opcode!==2'b00)begin $display("FAIL issue");errors=errors+1;end
        if(issue_rs!==8'd5||issue_rt!==8'd3)begin $display("FAIL issue data");errors=errors+1;end
        // Dispatch with operand not ready - should not issue immediately
        dispatch=1;rs_valid=1;rt_valid=0;opcode=2'b01;rs_data=8'd10;rt_data=8'd4;
        @(posedge clk);#1; dispatch=0;
        @(posedge clk);#1; if(issue!==0)begin $display("FAIL no issue when not ready");errors=errors+1;end
        if(errors==0) $display("PASS: OOO Issue Unit test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
