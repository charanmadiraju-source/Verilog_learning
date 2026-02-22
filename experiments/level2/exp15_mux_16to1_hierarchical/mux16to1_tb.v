`timescale 1ns/1ps
module mux16to1_tb;
    reg [15:0] d; reg [3:0] sel; wire y;
    mux16to1 uut(.d(d),.sel(sel),.y(y));
    integer i, errors=0;
    initial begin
        $dumpfile("mux16to1.vcd"); $dumpvars(0,mux16to1_tb);
        for(i=0;i<16;i=i+1) begin
            d = 16'd1 << i; sel = i[3:0]; #10;
            if(y!==1'b1) begin $display("FAIL sel=%0d",i); errors=errors+1; end
        end
        if(errors==0) $display("PASS: 16-to-1 MUX (hierarchical) test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
