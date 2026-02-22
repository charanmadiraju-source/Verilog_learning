`timescale 1ns/1ps
module cordic_vectoring_tb;
    reg signed [15:0] x_in,y_in; wire signed [15:0] angle;
    cordic_vectoring uut(.x_in(x_in),.y_in(y_in),.angle(angle));
    integer errors=0;
    initial begin
        $dumpfile("cordic_vectoring.vcd"); $dumpvars(0,cordic_vectoring_tb);
        // arctan(0) = 0: vector along x-axis
        x_in=16'h1000; y_in=16'h0; #10;
        if(angle < -200 || angle > 200) begin
            $display("FAIL arctan(0)=%0d expected ~0",angle); errors=errors+1;
        end
        // arctan(1) = 45 degrees ~ 16384 (pi/4 in Q0.15 scaled to pi/2)
        x_in=16'h1000; y_in=16'h1000; #10;
        if(angle < 15000 || angle > 18000) begin
            $display("FAIL arctan(1)=%0d expected ~16384",angle); errors=errors+1;
        end
        if(errors==0) $display("PASS: CORDIC Vectoring test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
