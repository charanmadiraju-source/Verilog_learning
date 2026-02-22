`timescale 1ns/1ps
module johnson_counter_4bit_tb;
    reg clk=0,rst; wire [3:0] q;
    always #5 clk=~clk;
    johnson_counter_4bit uut(.clk(clk),.rst(rst),.q(q));
    integer errors=0;
    // Expected 8-state sequence starting from 0000
    reg [3:0] expected[0:7];
    integer i;
    initial begin
        $dumpfile("johnson_counter_4bit.vcd"); $dumpvars(0,johnson_counter_4bit_tb);
        expected[0]=4'b0000; expected[1]=4'b0001; expected[2]=4'b0011;
        expected[3]=4'b0111; expected[4]=4'b1111; expected[5]=4'b1110;
        expected[6]=4'b1100; expected[7]=4'b1000;
        rst=1; @(posedge clk);#1; rst=0;
        for(i=0;i<8;i=i+1) begin
            if(q!==expected[i])begin $display("FAIL step %0d q=%b exp=%b",i,q,expected[i]);errors=errors+1;end
            @(posedge clk);#1;
        end
        if(q!==4'b0000)begin $display("FAIL wrap");errors=errors+1;end
        if(errors==0) $display("PASS: Johnson Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
