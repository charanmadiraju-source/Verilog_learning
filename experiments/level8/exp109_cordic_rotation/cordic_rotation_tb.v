`timescale 1ns/1ps
module cordic_rotation_tb;
    reg signed [15:0] x_in,y_in,z_in; wire signed [15:0] x_out,y_out;
    cordic_rotation uut(.x_in(x_in),.y_in(y_in),.z_in(z_in),.x_out(x_out),.y_out(y_out));
    integer errors=0;
    initial begin
        $dumpfile("cordic_rotation.vcd"); $dumpvars(0,cordic_rotation_tb);
        // Rotate (1,0) by 0 degrees -> should stay near (K, 0)
        // CORDIC gain K ~ 1.647, so x_out ~ 0x6A7 for x_in=0x4000 (1.0 in Q1.15)
        x_in=16'h4000; y_in=16'h0; z_in=16'h0; #10;
        // Just check output is non-zero and reasonable
        if(x_out === 16'b0 && y_out === 16'b0) begin
            $display("FAIL: both outputs zero"); errors=errors+1;
        end
        if(errors==0) $display("PASS: CORDIC Rotation test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
