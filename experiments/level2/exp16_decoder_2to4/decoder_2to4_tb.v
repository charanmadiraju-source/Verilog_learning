`timescale 1ns/1ps
module decoder_2to4_tb;
    reg [1:0] in; reg en; wire [3:0] out;
    decoder_2to4 uut(.in(in),.en(en),.out(out));
    integer i, errors=0;
    initial begin
        $dumpfile("decoder_2to4.vcd"); $dumpvars(0,decoder_2to4_tb);
        en=0; in=2'b00; #10; if(out!==4'b0000) begin $display("FAIL en=0"); errors=errors+1; end
        en=1;
        for(i=0;i<4;i=i+1) begin
            in=i[1:0]; #10;
            if(out !== (4'b0001<<i)) begin $display("FAIL in=%0d out=%b",i,out); errors=errors+1; end
        end
        if(errors==0) $display("PASS: 2-to-4 Decoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
