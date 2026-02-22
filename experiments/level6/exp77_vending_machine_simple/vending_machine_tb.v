`timescale 1ns/1ps
module vending_machine_tb;
    reg clk=0,rst,nickel,dime; wire dispense,change;
    always #5 clk=~clk;
    vending_machine uut(.clk(clk),.rst(rst),.nickel(nickel),.dime(dime),.dispense(dispense),.change(change));
    integer errors=0;
    initial begin
        $dumpfile("vending_machine.vcd"); $dumpvars(0,vending_machine_tb);
        rst=1;nickel=0;dime=0; @(posedge clk);#1; rst=0;
        // 5+10=15 -> dispense, no change
        nickel=1; @(posedge clk);#1; nickel=0;  // total=5
        dime=1;   @(posedge clk);#1; dime=0;    // total=15
        @(posedge clk);#1;                       // check: 15>=15 -> dispense=1
        if(dispense!==1)begin $display("FAIL dispense 5+10");errors=errors+1;end
        if(change!==0)begin $display("FAIL no change");errors=errors+1;end
        // 10+10=20 -> dispense with change
        dime=1; @(posedge clk);#1; dime=0; // total=10
        dime=1; @(posedge clk);#1; dime=0; // total=20
        @(posedge clk);#1;                  // check: 20>=15 -> dispense=1, change=1
        if(dispense!==1)begin $display("FAIL dispense 10+10");errors=errors+1;end
        if(change!==1)begin $display("FAIL change 10+10 got %b",change);errors=errors+1;end
        if(errors==0) $display("PASS: Vending Machine test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
