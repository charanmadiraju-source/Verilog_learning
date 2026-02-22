`timescale 1ns/1ps
module hamming_dec_tb;
    reg [6:0] r; wire [3:0] d; wire error; wire [2:0] err_pos;
    hamming_dec uut(.r(r),.d(d),.error(error),.err_pos(err_pos));
    integer errors=0;
    initial begin
        $dumpfile("hamming_dec.vcd"); $dumpvars(0,hamming_dec_tb);
        // Valid codeword: encoder(4'b1011) = 7'b1010101
        r=7'b1010101;#5;
        if(error!==0||d!==4'b1011)begin $display("FAIL no-error: d=%b err=%b pos=%b",d,error,err_pos);errors=errors+1;end
        // Inject single-bit error at position 1 (bit[0]): 1010100
        r=7'b1010100;#5;
        if(!error)begin $display("FAIL should detect error");errors=errors+1;end
        if(d!==4'b1011)begin $display("FAIL corrected d=%b (expected 1011)",d);errors=errors+1;end
        // All zeros - valid codeword for d=0000
        r=7'b0000000;#5;
        if(error!==0||d!==4'b0000)begin $display("FAIL all-zero: d=%b err=%b",d,error);errors=errors+1;end
        if(errors==0) $display("PASS: Hamming(7,4) Decoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
