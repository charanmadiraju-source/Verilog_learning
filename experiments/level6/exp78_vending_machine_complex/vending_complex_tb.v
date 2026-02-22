`timescale 1ns/1ps
module vending_complex_tb;
    reg clk=0,rst,nickel,dime,quarter; wire dispense; wire [4:0] change;
    always #5 clk=~clk;
    vending_complex uut(.clk(clk),.rst(rst),.nickel(nickel),.dime(dime),.quarter(quarter),.dispense(dispense),.change(change));
    integer errors=0;
    initial begin
        $dumpfile("vending_complex.vcd"); $dumpvars(0,vending_complex_tb);
        rst=1;nickel=0;dime=0;quarter=0; @(posedge clk);#1; rst=0;
        // Quarter -> dispense no change (total 25 -> 0)
        quarter=1; @(posedge clk);#1; quarter=0;
        @(posedge clk);#1;
        if(dispense!==1||change!==0)begin $display("FAIL quarter disp=%b chg=%0d",dispense,change);errors=errors+1;end
        // 10+10+5=25 -> dispense no change
        dime=1; @(posedge clk);#1; dime=0;
        dime=1; @(posedge clk);#1; dime=0;
        nickel=1; @(posedge clk);#1; nickel=0;
        @(posedge clk);#1;
        if(dispense!==1||change!==0)begin $display("FAIL exact change disp=%b chg=%0d",dispense,change);errors=errors+1;end
        // Insert nickel+dime simultaneously for 15c; then quarter for total 40 -> dispense + 15c change
        nickel=1;dime=1; @(posedge clk);#1; nickel=0;dime=0; // only nickel taken (else-if: nickel before dime? no: quarter>dime>nickel)
        // RTL processes: quarter? no. dime? yes -> total=10
        quarter=1; @(posedge clk);#1; quarter=0; // total=35
        @(posedge clk);#1;
        if(dispense!==1)begin $display("FAIL overpay disp=%b chg=%0d",dispense,change);errors=errors+1;end
        if(errors==0) $display("PASS: Complex Vending Machine test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
