`timescale 1ns/1ps
module mux8to1_tb;
    reg [7:0] d; reg [2:0] sel; wire y;
    mux8to1 uut(.d(d),.sel(sel),.y(y));
    integer i, errors=0;
    initial begin
        $dumpfile("mux8to1.vcd"); $dumpvars(0,mux8to1_tb);
        for(i=0;i<8;i=i+1) begin
            d = 8'd1 << i; sel = i[2:0]; #10;
            if(y!==1'b1) begin $display("FAIL sel=%0d",i); errors=errors+1; end
        end
        d=8'b00000000; sel=3'd3; #10;
        if(y!==1'b0) begin $display("FAIL zero check"); errors=errors+1; end
        if(errors==0) $display("PASS: 8-to-1 MUX (behavioral) test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
