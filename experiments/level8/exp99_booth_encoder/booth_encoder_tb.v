`timescale 1ns/1ps
module booth_encoder_tb;
    reg [2:0] y; wire neg,zero;
    booth_encoder uut(.y(y),.neg(neg),.zero(zero));
    integer errors=0;
    initial begin
        $dumpfile("booth_encoder.vcd"); $dumpvars(0,booth_encoder_tb);
        y=3'b000;#5; if(neg!==0||zero!==1)begin $display("FAIL 000");errors=errors+1;end
        y=3'b001;#5; if(neg!==0||zero!==0)begin $display("FAIL 001");errors=errors+1;end
        y=3'b111;#5; if(neg!==0||zero!==1)begin $display("FAIL 111");errors=errors+1;end
        y=3'b100;#5; if(neg!==1||zero!==0)begin $display("FAIL 100");errors=errors+1;end
        y=3'b101;#5; if(neg!==1||zero!==0)begin $display("FAIL 101");errors=errors+1;end
        if(errors==0) $display("PASS: Booth Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
