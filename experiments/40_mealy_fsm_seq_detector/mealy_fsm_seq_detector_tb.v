// Mealy FSM Sequence Detector Testbench
`timescale 1ns/1ps
module mealy_fsm_seq_detector_tb;
    reg  clk, rst_n, in;
    wire out;

    mealy_fsm_seq_detector uut (.clk(clk),.rst_n(rst_n),.in(in),.out(out));

    always #5 clk = ~clk;

    task send_bit;
        input b;
        begin in=b; @(posedge clk); #1; end
    endtask

    initial begin
        $dumpfile("mealy_fsm_seq_detector.vcd");
        $dumpvars(0, mealy_fsm_seq_detector_tb);
        clk=0; rst_n=0; in=0; #12; rst_n=1;
        // Sequence: 1 0 1 1  -> detect on 4th bit
        // Mealy output is combinational: sample BEFORE posedge captures next state
        send_bit(1); send_bit(0); send_bit(1);
        // State is now S3; set in=1 and check output before the clock edge
        in=1; #1;
        if (out!==1) $display("FAIL: expected detect after 1011");
        @(posedge clk); #1;  // consume the edge (transitions to S1)
        // Overlapping: from S1 with in=0,1 reaches S3 again
        send_bit(0); send_bit(1);
        // State is now S3 (after S2→S3), in is still 1 → out=1
        in=1; #1;
        if (out!==1) $display("FAIL: overlapping 1011 detect");
        @(posedge clk); #1;
        $display("Mealy FSM Sequence Detector test complete.");
        $finish;
    end
endmodule
