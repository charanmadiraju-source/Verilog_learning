`timescale 1ns/1ps
module fir_filter_4tap_tb;
    reg clk=0,rst; reg signed [7:0] x_in; wire signed [15:0] y_out;
    always #5 clk=~clk;
    fir_filter_4tap uut(.clk(clk),.rst(rst),.x_in(x_in),.y_out(y_out));
    integer errors=0;
    initial begin
        $dumpfile("fir_filter_4tap.vcd"); $dumpvars(0,fir_filter_4tap_tb);
        rst=1;x_in=0; @(posedge clk);#1; rst=0;
        // Impulse: x[0]=8, x[1..]=0
        // After 4 cycles, expected outputs: 8,16,16,8 (h scaled by 8)
        x_in=8'sd8; @(posedge clk);#1; if(y_out!==8)begin $display("FAIL y0=%0d",y_out);errors=errors+1;end
        x_in=0; @(posedge clk);#1; if(y_out!==16)begin $display("FAIL y1=%0d",y_out);errors=errors+1;end
        @(posedge clk);#1; if(y_out!==16)begin $display("FAIL y2=%0d",y_out);errors=errors+1;end
        @(posedge clk);#1; if(y_out!==8) begin $display("FAIL y3=%0d",y_out);errors=errors+1;end
        @(posedge clk);#1; if(y_out!==0) begin $display("FAIL y4=%0d",y_out);errors=errors+1;end
        if(errors==0) $display("PASS: FIR Filter test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
