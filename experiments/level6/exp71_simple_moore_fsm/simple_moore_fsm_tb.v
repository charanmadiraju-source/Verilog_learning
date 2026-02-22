`timescale 1ns/1ps
module simple_moore_fsm_tb;
    reg clk=0,rst,x; wire y;
    always #5 clk=~clk;
    simple_moore_fsm uut(.clk(clk),.rst(rst),.x(x),.y(y));
    integer errors=0;
    initial begin
        $dumpfile("simple_moore_fsm.vcd"); $dumpvars(0,simple_moore_fsm_tb);
        rst=1;x=0; @(posedge clk);#1; rst=0;
        // IDLE->S1->S2: y should be 1 in S2
        x=1; @(posedge clk);#1; if(y!==0)begin $display("FAIL S1 y should be 0");errors=errors+1;end
        x=1; @(posedge clk);#1; if(y!==1)begin $display("FAIL S2 y should be 1");errors=errors+1;end
        @(posedge clk);#1; if(y!==0)begin $display("FAIL back to IDLE");errors=errors+1;end
        // IDLE->S1->IDLE (x=0)
        x=1; @(posedge clk);#1;
        x=0; @(posedge clk);#1; if(y!==0)begin $display("FAIL back to IDLE via x=0");errors=errors+1;end
        if(errors==0) $display("PASS: Simple Moore FSM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
