// 4-to-2 Encoder Testbench
`timescale 1ns/1ps
module encoder_4to2_tb;
    reg  [3:0] in;
    wire [1:0] out;

    encoder_4to2 uut (.in(in),.out(out));

    initial begin
        $dumpfile("encoder_4to2.vcd");
        $dumpvars(0, encoder_4to2_tb);
        in=4'b0001; #10; if(out!==2'b00) $display("FAIL in=0001");
        in=4'b0010; #10; if(out!==2'b01) $display("FAIL in=0010");
        in=4'b0100; #10; if(out!==2'b10) $display("FAIL in=0100");
        in=4'b1000; #10; if(out!==2'b11) $display("FAIL in=1000");
        $display("4-to-2 Encoder test complete.");
        $finish;
    end
endmodule
