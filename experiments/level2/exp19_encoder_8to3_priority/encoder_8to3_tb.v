`timescale 1ns/1ps
module encoder_8to3_tb;
    reg [7:0] in; wire [2:0] out; wire valid;
    encoder_8to3 uut(.in(in),.out(out),.valid(valid));
    integer i, errors=0;
    initial begin
        $dumpfile("encoder_8to3.vcd"); $dumpvars(0,encoder_8to3_tb);
        in=8'd0;#10; if(valid!==0)begin $display("FAIL no input");errors=errors+1;end
        for(i=0;i<8;i=i+1) begin
            in=8'b00000001<<i; #10;
            if(out!==i[2:0]||valid!==1) begin $display("FAIL i=%0d",i);errors=errors+1;end
        end
        in=8'b10110000;#10; if(out!==3'd7||valid!==1)begin $display("FAIL priority");errors=errors+1;end
        if(errors==0) $display("PASS: 8-to-3 Priority Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
