`timescale 1ns/1ps
module delay_counter_tb;
    reg clk=0,rst,start; reg [7:0] timeout_val; wire done;
    always #5 clk=~clk;
    delay_counter #(.WIDTH(8)) uut(.clk(clk),.rst(rst),.start(start),.timeout_val(timeout_val),.done(done));
    integer i,errors=0;
    integer done_seen;
    initial begin
        $dumpfile("delay_counter.vcd"); $dumpvars(0,delay_counter_tb);
        rst=1;start=0;timeout_val=8'd5; @(posedge clk);#1; rst=0;
        start=1; @(posedge clk);#1; start=0;
        done_seen=0;
        for(i=0;i<8;i=i+1) begin
            if(done) done_seen=done_seen+1;
            @(posedge clk);#1;
        end
        if(done_seen!==1)begin $display("FAIL done seen %0d times",done_seen);errors=errors+1;end
        if(errors==0) $display("PASS: Delay Counter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
