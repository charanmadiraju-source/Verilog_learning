// Moore FSM Sequence Detector Testbench
`timescale 1ns/1ps
module moore_fsm_seq_detector_tb;
    reg  clk, rst_n, in;
    wire out;

    moore_fsm_seq_detector uut (.clk(clk),.rst_n(rst_n),.in(in),.out(out));

    always #5 clk = ~clk;

    task send_bit;
        input b;
        begin in=b; @(posedge clk); #1; end
    endtask

    initial begin
        $dumpfile("moore_fsm_seq_detector.vcd");
        $dumpvars(0, moore_fsm_seq_detector_tb);
        clk=0; rst_n=0; in=0; #12; rst_n=1;
        // Input: 1 0 1 1 0 1 0 1
        //              ^       ^  (detect at positions 3 and 8)
        send_bit(1); send_bit(0); send_bit(1);
        if (out!==1) $display("FAIL: expected detect after 101");
        send_bit(1); send_bit(0); send_bit(1);
        if (out!==1) $display("FAIL: expected detect at overlapping 101");
        send_bit(0); send_bit(1);
        $display("Moore FSM Sequence Detector test complete.");
        $finish;
    end
endmodule
