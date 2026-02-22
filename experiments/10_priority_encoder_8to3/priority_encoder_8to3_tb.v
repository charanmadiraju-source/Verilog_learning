// 8-to-3 Priority Encoder Testbench
`timescale 1ns/1ps
module priority_encoder_8to3_tb;
    reg  [7:0] in;
    wire [2:0] out;
    wire valid;

    priority_encoder_8to3 uut (.in(in),.out(out),.valid(valid));

    initial begin
        $dumpfile("priority_encoder_8to3.vcd");
        $dumpvars(0, priority_encoder_8to3_tb);
        in=8'b00000000; #10; if(valid!==0) $display("FAIL: no input");
        in=8'b00000001; #10; if(out!==3'd0||valid!==1) $display("FAIL in[0]");
        in=8'b00000011; #10; if(out!==3'd1||valid!==1) $display("FAIL in[1] priority");
        in=8'b10000000; #10; if(out!==3'd7||valid!==1) $display("FAIL in[7]");
        in=8'b01100000; #10; if(out!==3'd6||valid!==1) $display("FAIL in[6] priority");
        $display("8-to-3 Priority Encoder test complete.");
        $finish;
    end
endmodule
