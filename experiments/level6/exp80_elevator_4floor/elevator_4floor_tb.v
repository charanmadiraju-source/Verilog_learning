`timescale 1ns/1ps
module elevator_4floor_tb;
    reg clk=0,rst; reg [3:0] req; wire [1:0] current_floor; wire door_open;
    always #5 clk=~clk;
    elevator_4floor uut(.clk(clk),.rst(rst),.req(req),.current_floor(current_floor),.door_open(door_open));
    integer errors=0;
    initial begin
        $dumpfile("elevator_4floor.vcd"); $dumpvars(0,elevator_4floor_tb);
        rst=1;req=0; @(posedge clk);#1; rst=0;
        req=4'b1000; @(posedge clk);#1; req=0; // request floor 3
        repeat(10) @(posedge clk);#1;
        if(current_floor!==2'd3)begin $display("FAIL reach floor3 got %0d",current_floor);errors=errors+1;end
        if(errors==0) $display("PASS: Elevator 4-floor test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
