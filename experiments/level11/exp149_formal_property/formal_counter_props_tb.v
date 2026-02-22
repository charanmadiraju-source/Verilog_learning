`timescale 1ns/1ps
module formal_counter_props_tb;
    reg clk=0,rst,en; wire [3:0] count;
    always #5 clk=~clk;
    formal_counter_props uut(.clk(clk),.rst(rst),.en(en),.count(count));
    integer errors=0;
    initial begin
        $dumpfile("formal_counter_props.vcd"); $dumpvars(0,formal_counter_props_tb);
        rst=1;en=0; @(posedge clk);#1; rst=0;
        if(count!==0)begin $display("FAIL reset");errors=errors+1;end
        // Increment 16 times, should wrap around
        en=1;
        repeat(20) @(posedge clk);#1;
        en=0;
        // After 20 increments with 4-bit counter: 20 mod 16 = 4
        if(count!==4'd4)begin $display("FAIL count after 20: %0d",count);errors=errors+1;end
        if(errors==0) $display("PASS: Formal Counter Properties test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
