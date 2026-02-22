`timescale 1ns/1ps
module lifo_stack_tb;
    reg clk=0,rst,push,pop; reg [7:0] din; wire [7:0] dout; wire full,empty,overflow,underflow;
    always #5 clk=~clk;
    lifo_stack #(.DEPTH(8),.WIDTH(8)) uut(.clk(clk),.rst(rst),.push(push),.pop(pop),.din(din),.dout(dout),
               .full(full),.empty(empty),.overflow(overflow),.underflow(underflow));
    integer errors=0;
    initial begin
        $dumpfile("lifo_stack.vcd"); $dumpvars(0,lifo_stack_tb);
        rst=1;push=0;pop=0; @(posedge clk);#1; rst=0;
        if(empty!==1)begin $display("FAIL not empty");errors=errors+1;end
        // Push 3 values
        push=1;din=8'h11; @(posedge clk);#1;
        din=8'h22; @(posedge clk);#1;
        din=8'h33; @(posedge clk);#1; push=0;
        if(dout!==8'h33)begin $display("FAIL top=%h",dout);errors=errors+1;end
        // Pop
        pop=1; @(posedge clk);#1;
        if(dout!==8'h22)begin $display("FAIL pop1=%h",dout);errors=errors+1;end
        @(posedge clk);#1;
        if(dout!==8'h11)begin $display("FAIL pop2=%h",dout);errors=errors+1;end
        @(posedge clk);#1; pop=0;
        if(empty!==1)begin $display("FAIL empty after 3 pops");errors=errors+1;end
        if(errors==0) $display("PASS: LIFO Stack test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
