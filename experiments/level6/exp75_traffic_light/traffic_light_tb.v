`timescale 1ns/1ps
module traffic_light_tb;
    reg clk=0,rst; wire red,yellow,green;
    always #5 clk=~clk;
    traffic_light #(.RED_TIME(4),.GREEN_TIME(3),.YELLOW_TIME(2)) uut(.clk(clk),.rst(rst),.red(red),.yellow(yellow),.green(green));
    integer errors=0;
    initial begin
        $dumpfile("traffic_light.vcd"); $dumpvars(0,traffic_light_tb);
        rst=1; @(posedge clk);#1; rst=0;
        if(red!==1)begin $display("FAIL initial red");errors=errors+1;end
        // Wait through RED (4 cycles)
        repeat(4) @(posedge clk);#1;
        if(green!==1)begin $display("FAIL green after red");errors=errors+1;end
        // Wait through GREEN (3 cycles)
        repeat(3) @(posedge clk);#1;
        if(yellow!==1)begin $display("FAIL yellow after green");errors=errors+1;end
        // Wait through YELLOW (2 cycles)
        repeat(2) @(posedge clk);#1;
        if(red!==1)begin $display("FAIL red after yellow");errors=errors+1;end
        if(errors==0) $display("PASS: Traffic Light test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
