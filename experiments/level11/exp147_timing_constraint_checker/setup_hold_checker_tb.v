`timescale 1ns/1ps
module setup_hold_checker_tb;
    reg clk=0, data=0;
    wire setup_violation, hold_violation;
    setup_hold_checker #(.SETUP_TIME(2.0),.HOLD_TIME(1.0)) uut(.clk(clk),.data(data),.setup_violation(setup_violation),.hold_violation(hold_violation));
    always #10 clk=~clk; // 50 MHz
    integer errors=0;
    initial begin
        $dumpfile("setup_hold_checker.vcd"); $dumpvars(0,setup_hold_checker_tb);
        // Valid: data changes well before clock (5ns before posedge)
        data=0; #5; data=1; #5; @(posedge clk); // data was stable 5ns before edge
        #2; // Hold time satisfied
        if(setup_violation)begin $display("FAIL false setup violation");errors=errors+1;end
        if(errors==0) $display("PASS: Timing Constraint Checker test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
