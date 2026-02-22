// Single-Port RAM Testbench
`timescale 1ns/1ps
module single_port_ram_tb;
    reg        clk, we;
    reg  [7:0] addr, din;
    wire [7:0] dout;

    single_port_ram uut (.clk(clk),.we(we),.addr(addr),.din(din),.dout(dout));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("single_port_ram.vcd");
        $dumpvars(0, single_port_ram_tb);
        clk=0; we=0;
        // Write 0-15 to addresses 0-15
        we=1;
        for (i=0; i<16; i=i+1) begin
            addr=i[7:0]; din=i[7:0]; @(posedge clk); #1;
        end
        we=0;
        // Read back
        for (i=0; i<16; i=i+1) begin
            addr=i[7:0]; @(posedge clk); #1;
            if (dout !== i[7:0]) $display("FAIL addr=%0d dout=%0d", i, dout);
        end
        $display("Single-Port RAM test complete.");
        $finish;
    end
endmodule
