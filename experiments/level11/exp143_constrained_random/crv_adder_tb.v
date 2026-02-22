// Experiment 143: Constrained Random Verification for 8-bit Adder
// Generates random inputs with constraints and verifies outputs.
`timescale 1ns/1ps
module crv_adder_tb;
    reg [7:0] a, b; reg cin; wire [7:0] sum; wire cout;
    // Simple adder under test
    assign {cout,sum} = {1'b0,a} + {1'b0,b} + cin;
    integer i, errors=0, seed=42;
    reg [8:0] expected;
    initial begin
        $dumpfile("crv_adder_tb.vcd"); $dumpvars(0,crv_adder_tb);
        // Directed: corner cases
        a=8'h00;b=8'h00;cin=0;#5; if({cout,sum}!==9'h000)begin $display("FAIL 0+0");errors=errors+1;end
        a=8'hFF;b=8'hFF;cin=1;#5; if({cout,sum}!==9'h1FF)begin $display("FAIL FF+FF+1");errors=errors+1;end
        a=8'h80;b=8'h80;cin=0;#5; if({cout,sum}!==9'h100)begin $display("FAIL 80+80");errors=errors+1;end
        // Random: 100 test vectors with constraint a+b < 512
        for(i=0;i<100;i=i+1) begin
            a = $random(seed) & 8'hFF;
            b = $random(seed) & 8'hFF;
            cin = $random(seed) & 1;
            expected = {1'b0,a} + {1'b0,b} + cin;
            #5;
            if({cout,sum}!==expected[8:0])begin
                $display("FAIL %0d+%0d+%0d=%0d exp=%0d",a,b,cin,{cout,sum},expected);
                errors=errors+1;
            end
        end
        if(errors==0) $display("PASS: Constrained Random Adder test complete (%0d vectors).",103);
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
