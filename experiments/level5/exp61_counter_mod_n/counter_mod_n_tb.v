`timescale 1ns/1ps
module counter_mod_n_tb;
    reg clk=0,rst; wire [3:0] count; wire tc;
    always #5 clk=~clk;
    counter_mod_n #(.N(10)) uut(.clk(clk),.rst(rst),.count(count),.tc(tc));
    integer i,errors=0;
    initial begin
        $dumpfile("counter_mod_n.vcd"); $dumpvars(0,counter_mod_n_tb);
        rst=1; @(posedge clk);#1; rst=0;
        for(i=0;i<10;i=i+1) begin
            if(count!==i)begin $display("FAIL count=%0d exp=%0d",count,i);errors=errors+1;end
            @(posedge clk);#1;
        end
        if(count!==0)begin $display("FAIL modulo reset");errors=errors+1;end
        if(errors==0) $display("PASS: Mod-N Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
