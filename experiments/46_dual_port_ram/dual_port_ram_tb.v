// Dual-Port RAM Testbench
`timescale 1ns/1ps
module dual_port_ram_tb;
    reg        clk, we;
    reg  [7:0] waddr, raddr, din;
    wire [7:0] dout;

    dual_port_ram uut (.clk(clk),.we(we),.waddr(waddr),.din(din),.raddr(raddr),.dout(dout));

    always #5 clk = ~clk;

    integer i;
    initial begin
        $dumpfile("dual_port_ram.vcd");
        $dumpvars(0, dual_port_ram_tb);
        clk=0; we=0;
        we=1;
        for (i=0; i<8; i=i+1) begin
            waddr=i[7:0]; din=8'd100+i; @(posedge clk); #1;
        end
        we=0;
        for (i=0; i<8; i=i+1) begin
            raddr=i[7:0]; @(posedge clk); #1;
            if (dout !== 8'd100+i) $display("FAIL raddr=%0d dout=%0d exp=%0d", i, dout, 100+i);
        end
        $display("Dual-Port RAM test complete.");
        $finish;
    end
endmodule
