`timescale 1ns/1ps
module pipe_adder_2stage_tb;
    reg clk=0,rst; reg [7:0] a,b; wire [7:0] sum; wire cout;
    always #5 clk=~clk;
    pipe_adder_2stage uut(.clk(clk),.rst(rst),.a(a),.b(b),.sum(sum),.cout(cout));
    integer errors=0;
    initial begin
        $dumpfile("pipe_adder_2stage.vcd"); $dumpvars(0,pipe_adder_2stage_tb);
        rst=1; @(posedge clk);#1; rst=0;
        a=8'd100;b=8'd56; @(posedge clk);#1; // stage1
        @(posedge clk);#1; // stage2: output ready
        if(sum!==8'd156||cout!==0)begin $display("FAIL 100+56=%0d",sum);errors=errors+1;end
        a=8'd200;b=8'd100; @(posedge clk);#1;
        @(posedge clk);#1;
        if({cout,sum}!==9'd300)begin $display("FAIL 200+100=%0d",{cout,sum});errors=errors+1;end
        if(errors==0) $display("PASS: 2-stage Pipeline Adder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
