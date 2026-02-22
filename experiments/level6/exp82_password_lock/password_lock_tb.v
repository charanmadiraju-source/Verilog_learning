`timescale 1ns/1ps
module password_lock_tb;
    reg clk=0,rst,digit_in; wire unlocked;
    always #5 clk=~clk;
    password_lock uut(.clk(clk),.rst(rst),.digit_in(digit_in),.unlocked(unlocked));
    integer errors=0;
    task send; input b; begin digit_in=b; @(posedge clk);#1; end endtask
    initial begin
        $dumpfile("password_lock.vcd"); $dumpvars(0,password_lock_tb);
        rst=1;digit_in=0; @(posedge clk);#1; rst=0;
        // Wrong sequence
        send(0);send(0);send(0);send(0);
        if(unlocked!==0)begin $display("FAIL wrong seq");errors=errors+1;end
        // Correct: 1,0,1,1
        send(1);send(0);send(1);
        send(1); if(unlocked!==1)begin $display("FAIL correct seq");errors=errors+1;end
        if(errors==0) $display("PASS: Password Lock test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
