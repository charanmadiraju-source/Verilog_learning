`timescale 1ns/1ps
module cdc_checker_tb;
    reg src_clk=0,dst_clk=0,rst; reg src_signal;
    wire dst_signal;
    // Two-flop synchronizer
    reg [1:0] sync_ff;
    always @(posedge dst_clk) sync_ff <= {sync_ff[0], src_signal};
    assign dst_signal = sync_ff[1];
    always #4 src_clk=~src_clk;   // 125 MHz
    always #6 dst_clk=~dst_clk;   // 83 MHz
    cdc_checker uut(.src_clk(src_clk),.dst_clk(dst_clk),.rst(rst),.src_signal(src_signal),.dst_signal(dst_signal));
    integer errors=0;
    initial begin
        $dumpfile("cdc_checker.vcd"); $dumpvars(0,cdc_checker_tb);
        rst=1;src_signal=0;sync_ff=0; #30; rst=0;
        // Toggle source signal
        @(posedge src_clk);#1; src_signal=1;
        repeat(5) @(posedge dst_clk);
        // dst_signal should eventually follow (2 sync flops)
        if(dst_signal!==1)begin $display("FAIL CDC not propagated");errors=errors+1;end
        @(posedge src_clk);#1; src_signal=0;
        repeat(5) @(posedge dst_clk);
        if(dst_signal!==0)begin $display("FAIL CDC 0 not propagated");errors=errors+1;end
        if(errors==0) $display("PASS: CDC Checker test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
