`timescale 1ns/1ps
module timer_wdog_tb;
    reg clk=0,rst,load,kick_wdog; reg [7:0] timer_val;
    wire timer_done,wdog_rst;
    always #5 clk=~clk;
    timer_wdog uut(.clk(clk),.rst(rst),.load(load),.timer_val(timer_val),.kick_wdog(kick_wdog),.timer_done(timer_done),.wdog_rst(wdog_rst));
    integer errors=0, i;
    reg saw_timer_done, saw_wdog_rst;
    initial begin
        $dumpfile("timer_wdog.vcd"); $dumpvars(0,timer_wdog_tb);
        rst=1; load=0; kick_wdog=0;
        @(posedge clk); #1; rst=0;
        // Load timer with 5 and immediately start counting (no watchdog kick)
        timer_val=8'd5; load=1; @(posedge clk); #1; load=0;
        saw_timer_done=0;
        for(i=0;i<10;i=i+1) begin @(posedge clk); #1; if(timer_done) saw_timer_done=1; end
        if(!saw_timer_done) begin $display("FAIL timer_done not seen");errors=errors+1; end
        // Now wait 25 cycles without kicking watchdog - wdog_rst should fire (20 cycles)
        // wdog_cnt started at reset and hasn't been kicked, so it should fire around cycle 20 from reset
        // We need to wait until enough cycles pass
        saw_wdog_rst=0;
        for(i=0;i<30;i=i+1) begin @(posedge clk); #1; if(wdog_rst) saw_wdog_rst=1; end
        if(!saw_wdog_rst) begin $display("FAIL wdog_rst never fired");errors=errors+1; end
        if(errors==0) $display("PASS: Timer/Watchdog test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
