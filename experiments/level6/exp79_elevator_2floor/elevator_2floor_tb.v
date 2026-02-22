`timescale 1ns/1ps
module elevator_2floor_tb;
    reg clk=0,rst,req_floor0,req_floor1; wire floor,door_open;
    always #5 clk=~clk;
    elevator_2floor uut(.clk(clk),.rst(rst),.req_floor0(req_floor0),.req_floor1(req_floor1),.floor(floor),.door_open(door_open));
    integer errors=0;
    initial begin
        $dumpfile("elevator_2floor.vcd"); $dumpvars(0,elevator_2floor_tb);
        rst=1;req_floor0=0;req_floor1=0; @(posedge clk);#1; rst=0;
        // Request floor 1
        req_floor1=1; @(posedge clk);#1; req_floor1=0;
        @(posedge clk);#1; if(floor!==1)begin $display("FAIL floor1");errors=errors+1;end
        @(posedge clk);#1; if(door_open!==1)begin $display("FAIL door open at floor1");errors=errors+1;end
        // Request floor 0
        req_floor0=1; @(posedge clk);#1; req_floor0=0;
        @(posedge clk);#1; if(floor!==0)begin $display("FAIL floor0");errors=errors+1;end
        @(posedge clk);#1; if(door_open!==1)begin $display("FAIL door open at floor0");errors=errors+1;end
        if(errors==0) $display("PASS: Elevator 2-floor test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
