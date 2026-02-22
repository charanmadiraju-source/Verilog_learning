`timescale 1ns/1ps
module datapath_pipe_tb;
    reg clk=0,rst; reg [1:0] opcode; reg [7:0] rs_data,rt_data;
    wire [7:0] wb_result; wire wb_valid;
    always #5 clk=~clk;
    datapath_pipe uut(.clk(clk),.rst(rst),.opcode(opcode),.rs_data(rs_data),.rt_data(rt_data),.wb_result(wb_result),.wb_valid(wb_valid));
    integer errors=0;
    initial begin
        $dumpfile("datapath_pipe.vcd"); $dumpvars(0,datapath_pipe_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Send ADD 10+20
        opcode=2'b00;rs_data=8'd10;rt_data=8'd20; @(posedge clk);#1;
        @(posedge clk);#1; @(posedge clk);#1; @(posedge clk);#1; // 4 stage latency
        if(wb_result!==8'd30||wb_valid!==1)begin $display("FAIL add %0d",wb_result);errors=errors+1;end
        if(errors==0) $display("PASS: 4-stage Datapath Pipeline test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
