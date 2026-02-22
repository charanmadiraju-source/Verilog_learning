`timescale 1ns/1ps
module encoder_4to2_tb;
    reg [3:0] in; wire [1:0] out; wire valid;
    encoder_4to2 uut(.in(in),.out(out),.valid(valid));
    integer errors=0;
    initial begin
        $dumpfile("encoder_4to2.vcd"); $dumpvars(0,encoder_4to2_tb);
        in=4'b0000;#10; if(valid!==0)begin $display("FAIL no input");errors=errors+1;end
        in=4'b0001;#10; if(out!==2'd0||valid!==1)begin $display("FAIL in=0001");errors=errors+1;end
        in=4'b0010;#10; if(out!==2'd1||valid!==1)begin $display("FAIL in=0010");errors=errors+1;end
        in=4'b0100;#10; if(out!==2'd2||valid!==1)begin $display("FAIL in=0100");errors=errors+1;end
        in=4'b1000;#10; if(out!==2'd3||valid!==1)begin $display("FAIL in=1000");errors=errors+1;end
        in=4'b1010;#10; if(out!==2'd3||valid!==1)begin $display("FAIL in=1010 priority");errors=errors+1;end
        if(errors==0) $display("PASS: 4-to-2 Priority Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
