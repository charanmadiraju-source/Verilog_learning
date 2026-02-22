`timescale 1ns/1ps
module ring_counter_4bit_tb;
    reg clk=0,rst; wire [3:0] q;
    always #5 clk=~clk;
    ring_counter_4bit uut(.clk(clk),.rst(rst),.q(q));
    integer errors=0;
    initial begin
        $dumpfile("ring_counter_4bit.vcd"); $dumpvars(0,ring_counter_4bit_tb);
        rst=1; #8; // hold reset past one posedge
        if(q!==4'b1000)begin $display("FAIL init q=%b",q);errors=errors+1;end
        rst=0;
        @(posedge clk);#1; if(q!==4'b0100)begin $display("FAIL step1 q=%b",q);errors=errors+1;end
        @(posedge clk);#1; if(q!==4'b0010)begin $display("FAIL step2 q=%b",q);errors=errors+1;end
        @(posedge clk);#1; if(q!==4'b0001)begin $display("FAIL step3 q=%b",q);errors=errors+1;end
        @(posedge clk);#1; if(q!==4'b1000)begin $display("FAIL wrap q=%b",q);errors=errors+1;end
        if(errors==0) $display("PASS: Ring Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
