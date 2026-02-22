// Testbench: Experiment 11 – 2-to-1 MUX (Gate-Level)
`timescale 1ns/1ps
module mux2to1_gate_tb;
    reg  a, b, sel;
    wire y;
    mux2to1_gate uut (.a(a), .b(b), .sel(sel), .y(y));
    integer errors = 0;
    initial begin
        $dumpfile("mux2to1_gate.vcd"); $dumpvars(0, mux2to1_gate_tb);
        a=0;b=0;sel=0;#10; if(y!==0) begin $display("FAIL: a=%b b=%b sel=%b y=%b",a,b,sel,y); errors=errors+1; end
        a=1;b=0;sel=0;#10; if(y!==1) begin $display("FAIL: a=%b b=%b sel=%b y=%b",a,b,sel,y); errors=errors+1; end
        a=0;b=1;sel=1;#10; if(y!==1) begin $display("FAIL: a=%b b=%b sel=%b y=%b",a,b,sel,y); errors=errors+1; end
        a=1;b=0;sel=1;#10; if(y!==0) begin $display("FAIL: a=%b b=%b sel=%b y=%b",a,b,sel,y); errors=errors+1; end
        if(errors==0) $display("PASS: 2-to-1 MUX (gate-level) test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
