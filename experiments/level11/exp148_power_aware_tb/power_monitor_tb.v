`timescale 1ns/1ps
module power_monitor_tb;
    reg clk=0,rst; reg [7:0] bus_signals;
    wire [31:0] toggle_count; wire [7:0] prev_state;
    always #5 clk=~clk;
    power_monitor uut(.clk(clk),.rst(rst),.bus_signals(bus_signals),.toggle_count(toggle_count),.prev_state(prev_state));
    integer errors=0;
    initial begin
        $dumpfile("power_monitor.vcd"); $dumpvars(0,power_monitor_tb);
        rst=1;bus_signals=0; @(posedge clk);#1; rst=0;
        // Static: no toggles
        bus_signals=8'hAA; @(posedge clk);#1; // first change: 4 bits toggle from 0
        @(posedge clk);#1;
        if(toggle_count!==4)begin $display("FAIL toggle_count=%0d exp=4",toggle_count);errors=errors+1;end
        // All bits toggle: 0xAA -> 0x55
        bus_signals=8'h55; @(posedge clk);#1;
        if(toggle_count!==12)begin $display("FAIL toggle_count=%0d exp=12",toggle_count);errors=errors+1;end
        // No change
        @(posedge clk);#1;
        if(toggle_count!==12)begin $display("FAIL toggle_count changed on no-toggle");errors=errors+1;end
        if(errors==0) $display("PASS: Power Monitor test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
