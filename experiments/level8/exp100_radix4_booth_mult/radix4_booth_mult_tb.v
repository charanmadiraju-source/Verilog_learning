`timescale 1ns/1ps
module radix4_booth_mult_tb;
    reg signed [7:0] a,b; wire signed [15:0] product;
    radix4_booth_mult uut(.a(a),.b(b),.product(product));
    integer errors=0;
    initial begin
        $dumpfile("radix4_booth_mult.vcd"); $dumpvars(0,radix4_booth_mult_tb);
        a=8'd5;b=8'd6;#10; if(product!==16'd30)begin $display("FAIL 5*6=%0d",product);errors=errors+1;end
        a=-8'd5;b=8'd6;#10; if(product!==-16'd30)begin $display("FAIL -5*6=%0d",product);errors=errors+1;end
        a=8'd12;b=-8'd8;#10; if(product!==-16'd96)begin $display("FAIL 12*-8=%0d",product);errors=errors+1;end
        a=8'd0;b=8'd100;#10; if(product!==16'd0)begin $display("FAIL 0*100=%0d",product);errors=errors+1;end
        if(errors==0) $display("PASS: Radix-4 Booth Multiplier test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
