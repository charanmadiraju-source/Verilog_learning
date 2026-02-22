`timescale 1ns/1ps
module risc4_tb;
    reg clk=0,rst; wire [1:0] pc; wire [7:0] alu_out;
    always #5 clk=~clk;
    risc4 uut(.clk(clk),.rst(rst),.pc(pc),.alu_out(alu_out));
    integer errors=0;
    initial begin
        $dumpfile("risc4.vcd"); $dumpvars(0,risc4_tb);
        rst=1; @(posedge clk);#1; rst=0;
        @(posedge clk);#1; // PC=0 executes ADD, alu_out=prev(0)
        @(posedge clk);#1; // PC=1 executes SUB, alu_out = result of ADD = 30
        if(alu_out!==8'd30)begin $display("FAIL ADD=%0d",alu_out);errors=errors+1;end
        @(posedge clk);#1; // PC=2 executes AND, alu_out = result of SUB = 25
        if(alu_out!==8'd25)begin $display("FAIL SUB=%0d",alu_out);errors=errors+1;end
        if(errors==0) $display("PASS: RISC4 CPU test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
