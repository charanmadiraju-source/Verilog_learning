`timescale 1ns/1ps
module branch_predictor_tb;
    reg clk=0,rst; reg [1:0] pc_index; reg actual_taken,update; wire predict_taken;
    always #5 clk=~clk;
    branch_predictor uut(.clk(clk),.rst(rst),.pc_index(pc_index),.actual_taken(actual_taken),.update(update),.predict_taken(predict_taken));
    integer errors=0;
    initial begin
        $dumpfile("branch_predictor.vcd"); $dumpvars(0,branch_predictor_tb);
        rst=1; @(posedge clk);#1; rst=0;
        pc_index=2'd0;
        // Initial state: 01 (WeakNotTaken) -> predict_taken=0
        update=0; #1; if(predict_taken!==0)begin $display("FAIL init predict");errors=errors+1;end
        // Update: taken twice -> should become 11 (StrongTaken) -> predict_taken=1
        actual_taken=1;update=1; @(posedge clk);#1;
        @(posedge clk);#1; update=0;
        if(predict_taken!==1)begin $display("FAIL after 2 taken pred=%b",predict_taken);errors=errors+1;end
        // Update: not-taken twice -> back to 01
        actual_taken=0;update=1; @(posedge clk);#1;
        @(posedge clk);#1; update=0;
        if(predict_taken!==0)begin $display("FAIL after 2 not-taken pred=%b",predict_taken);errors=errors+1;end
        if(errors==0) $display("PASS: Branch Predictor test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
