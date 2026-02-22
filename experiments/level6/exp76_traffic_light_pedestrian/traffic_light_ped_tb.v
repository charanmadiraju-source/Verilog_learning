`timescale 1ns/1ps
module traffic_light_ped_tb;
    reg clk=0,rst,ped_btn; wire red,yellow,green,walk;
    always #5 clk=~clk;
    traffic_light_ped #(.RED_TIME(4),.GREEN_TIME(6),.YELLOW_TIME(2),.WALK_TIME(4)) uut(
        .clk(clk),.rst(rst),.ped_btn(ped_btn),.red(red),.yellow(yellow),.green(green),.walk(walk));
    integer errors=0;
    initial begin
        $dumpfile("traffic_light_ped.vcd"); $dumpvars(0,traffic_light_ped_tb);
        rst=1;ped_btn=0; @(posedge clk);#1; rst=0;
        // Wait through RED
        repeat(4) @(posedge clk);#1;
        if(green!==1)begin $display("FAIL green");errors=errors+1;end
        // Press pedestrian button
        ped_btn=1; @(posedge clk);#1; ped_btn=0;
        @(posedge clk);#1; // move to YELLOW
        if(yellow!==1)begin $display("FAIL yellow after ped");errors=errors+1;end
        // Wait through YELLOW
        repeat(2) @(posedge clk);#1;
        if(walk!==1)begin $display("FAIL walk");errors=errors+1;end
        if(errors==0) $display("PASS: Traffic Light Pedestrian test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
