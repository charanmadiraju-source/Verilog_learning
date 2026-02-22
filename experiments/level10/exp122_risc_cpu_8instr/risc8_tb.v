`timescale 1ns/1ps
module risc8_tb;
    reg clk=0,rst; wire [3:0] pc; wire [7:0] result;
    always #5 clk=~clk;
    risc8 uut(.clk(clk),.rst(rst),.pc(pc),.result(result));
    integer errors=0;
    initial begin
        $dumpfile("risc8.vcd"); $dumpvars(0,risc8_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // After reset release: next clock executes PC=0 (ADD R3=R0+R1=13)
        @(posedge clk);#1;
        if(result!==8'd13)begin $display("FAIL ADD=%0d",result);errors=errors+1;end
        // PC=1: SUB R4=R3-R2=11 (R3 was just updated to 13)
        @(posedge clk);#1;
        if(result!==8'd11)begin $display("FAIL SUB=%0d",result);errors=errors+1;end
        if(errors==0) $display("PASS: RISC8 CPU test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
