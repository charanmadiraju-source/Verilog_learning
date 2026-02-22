`timescale 1ns/1ps
module bcd_to_7seg_tb;
    reg [3:0] bcd; wire [6:0] seg;
    bcd_to_7seg uut(.bcd(bcd),.seg(seg));
    // Expected segment patterns (active-low, gfedcba)
    reg [6:0] expected [0:9];
    integer i, errors=0;
    initial begin
        $dumpfile("bcd_to_7seg.vcd"); $dumpvars(0,bcd_to_7seg_tb);
        expected[0]=7'b1000000; expected[1]=7'b1111001;
        expected[2]=7'b0100100; expected[3]=7'b0110000;
        expected[4]=7'b0011001; expected[5]=7'b0010010;
        expected[6]=7'b0000010; expected[7]=7'b1111000;
        expected[8]=7'b0000000; expected[9]=7'b0010000;
        for(i=0;i<10;i=i+1) begin
            bcd=i[3:0]; #10;
            if(seg!==expected[i]) begin
                $display("FAIL bcd=%0d seg=%b exp=%b",i,seg,expected[i]);
                errors=errors+1; end
        end
        if(errors==0) $display("PASS: BCD to 7-seg test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
