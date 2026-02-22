`timescale 1ns/1ps
module scoreboard_tb;
    reg clk=0,rst,valid; reg [7:0] a,b; reg [15:0] dut_out;
    wire pass,fail; wire [31:0] pass_cnt,fail_cnt;
    always #5 clk=~clk;
    scoreboard uut(.clk(clk),.rst(rst),.valid(valid),.a(a),.b(b),.dut_out(dut_out),.pass(pass),.fail(fail),.pass_cnt(pass_cnt),.fail_cnt(fail_cnt));
    integer i,j,errors=0;
    initial begin
        $dumpfile("scoreboard.vcd"); $dumpvars(0,scoreboard_tb);
        rst=1; @(posedge clk);#1; rst=0;
        valid=1;
        // Test all 16x16 = 256 combinations using golden model directly
        for(i=0;i<16;i=i+1) for(j=0;j<16;j=j+1) begin
            a=i[7:0];b=j[7:0];dut_out=i*j; // dut_out = golden model
            @(posedge clk);#1;
        end
        valid=0; @(posedge clk);#1;
        if(fail_cnt!==0)begin $display("FAIL %0d scoreboard failures",fail_cnt);errors=errors+1;end
        if(pass_cnt!==256)begin $display("FAIL only %0d/256 passed",pass_cnt);errors=errors+1;end
        if(errors==0) $display("PASS: Scoreboard test complete (%0d pass, %0d fail).",pass_cnt,fail_cnt);
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
