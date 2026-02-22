// 4-to-16 Decoder Testbench
`timescale 1ns/1ps
module decoder_4to16_tb;
    reg  [3:0] in;
    reg  en;
    wire [15:0] out;

    decoder_4to16 uut (.in(in),.en(en),.out(out));

    integer i;
    initial begin
        $dumpfile("decoder_4to16.vcd");
        $dumpvars(0, decoder_4to16_tb);
        en=0; in=4'hF; #10;
        if (out !== 16'h0000) $display("FAIL: enable=0");
        en=1;
        for (i = 0; i < 16; i = i + 1) begin
            in = i[3:0]; #10;
            if (out !== (16'h0001 << i))
                $display("FAIL: in=%0d out=%b", i, out);
        end
        $display("4-to-16 Decoder test complete.");
        $finish;
    end
endmodule
