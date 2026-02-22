// BCD to 7-Segment Testbench
`timescale 1ns/1ps
module bcd_to_7seg_tb;
    reg  [3:0] bcd;
    wire [6:0] seg;

    bcd_to_7seg uut (.bcd(bcd),.seg(seg));

    reg [6:0] expected [0:9];
    integer i;

    initial begin
        expected[0]=7'b0111111; expected[1]=7'b0000110; expected[2]=7'b1011011;
        expected[3]=7'b1001111; expected[4]=7'b1100110; expected[5]=7'b1101101;
        expected[6]=7'b1111101; expected[7]=7'b0000111; expected[8]=7'b1111111;
        expected[9]=7'b1101111;

        $dumpfile("bcd_to_7seg.vcd");
        $dumpvars(0, bcd_to_7seg_tb);
        for (i = 0; i < 10; i = i + 1) begin
            bcd = i[3:0]; #10;
            if (seg !== expected[i])
                $display("FAIL: bcd=%0d seg=%b exp=%b", i, seg, expected[i]);
        end
        $display("BCD to 7-Segment test complete.");
        $finish;
    end
endmodule
