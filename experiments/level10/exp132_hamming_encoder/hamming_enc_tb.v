`timescale 1ns/1ps
module hamming_enc_tb;
    reg [3:0] d; wire [6:0] h;
    hamming_enc uut(.d(d),.h(h));
    integer errors=0;
    // Check parity by re-verifying syndromes
    reg [6:0] hval;
    reg s1,s2,s4;
    initial begin
        $dumpfile("hamming_enc.vcd"); $dumpvars(0,hamming_enc_tb);
        // d=4'b1011: verify output has zero syndrome (valid codeword)
        d=4'b1011; #5; hval=h;
        // Syndrome: s1 checks positions 1,3,5,7 (bits 6,4,2,0)
        s1=hval[6]^hval[4]^hval[2]^hval[0];
        s2=hval[5]^hval[4]^hval[1]^hval[0];
        s4=hval[3]^hval[2]^hval[1]^hval[0];
        if(s1!==0||s2!==0||s4!==0)begin $display("FAIL d=1011: h=%b not valid codeword (s=%b%b%b)",hval,s1,s2,s4);errors=errors+1;end
        // d=4'b0000 -> h should be all zeros (trivial)
        d=4'b0000;#5; if(h!==7'b0000000)begin $display("FAIL d=0000: h=%b",h);errors=errors+1;end
        // d=4'b1111 -> verify valid codeword
        d=4'b1111;#5; hval=h;
        s1=hval[6]^hval[4]^hval[2]^hval[0];
        s2=hval[5]^hval[4]^hval[1]^hval[0];
        s4=hval[3]^hval[2]^hval[1]^hval[0];
        if(s1!==0||s2!==0||s4!==0)begin $display("FAIL d=1111: h=%b not valid",hval);errors=errors+1;end
        if(errors==0) $display("PASS: Hamming(7,4) Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
