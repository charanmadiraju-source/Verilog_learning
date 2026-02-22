`timescale 1ns/1ps
module decoder_3to8_tb;
    reg [2:0] in; reg en; wire [7:0] out;
    decoder_3to8 uut(.in(in),.en(en),.out(out));
    integer i, errors=0;
    initial begin
        $dumpfile("decoder_3to8.vcd"); $dumpvars(0,decoder_3to8_tb);
        en=0; in=3'd0; #10; if(out!==8'd0) begin $display("FAIL en=0"); errors=errors+1; end
        en=1;
        for(i=0;i<8;i=i+1) begin
            in=i[2:0]; #10;
            if(out !== (8'b00000001<<i)) begin $display("FAIL in=%0d",i); errors=errors+1; end
        end
        if(errors==0) $display("PASS: 3-to-8 Decoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
