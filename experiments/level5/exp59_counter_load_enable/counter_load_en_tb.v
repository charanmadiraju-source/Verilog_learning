`timescale 1ns/1ps
module counter_load_en_tb;
    reg clk=0,rst,load,en; reg [3:0] d; wire [3:0] count;
    always #5 clk=~clk;
    counter_load_en uut(.clk(clk),.rst(rst),.load(load),.en(en),.d(d),.count(count));
    integer errors=0;
    initial begin
        $dumpfile("counter_load_en.vcd"); $dumpvars(0,counter_load_en_tb);
        rst=1;load=0;en=0;d=0; @(posedge clk);#1; rst=0;
        load=1;d=4'd7; @(posedge clk);#1;
        if(count!==4'd7)begin $display("FAIL load");errors=errors+1;end
        load=0;en=1; @(posedge clk);#1;
        if(count!==4'd8)begin $display("FAIL en");errors=errors+1;end
        en=0; @(posedge clk);#1;
        if(count!==4'd8)begin $display("FAIL hold");errors=errors+1;end
        if(errors==0) $display("PASS: Counter Load/Enable test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
