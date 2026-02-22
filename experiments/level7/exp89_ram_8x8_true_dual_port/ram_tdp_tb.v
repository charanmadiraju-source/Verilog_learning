`timescale 1ns/1ps
module ram_tdp_tb;
    reg clk=0;
    reg en_a=0,we_a=0; reg [2:0] addr_a; reg [7:0] din_a; wire [7:0] dout_a;
    reg en_b=0,we_b=0; reg [2:0] addr_b; reg [7:0] din_b; wire [7:0] dout_b;
    always #5 clk=~clk;
    ram_tdp uut(.clk(clk),.en_a(en_a),.we_a(we_a),.addr_a(addr_a),.din_a(din_a),.dout_a(dout_a),
                .en_b(en_b),.we_b(we_b),.addr_b(addr_b),.din_b(din_b),.dout_b(dout_b));
    integer errors=0;
    initial begin
        $dumpfile("ram_tdp.vcd"); $dumpvars(0,ram_tdp_tb);
        // Port A write to addr 0
        en_a=1;we_a=1;addr_a=3'd0;din_a=8'hAA; @(posedge clk);#1;
        // Port B write to addr 1
        en_a=0;we_a=0; en_b=1;we_b=1;addr_b=3'd1;din_b=8'hBB; @(posedge clk);#1;
        // Read both
        en_a=1;we_a=0;addr_a=3'd0; en_b=1;we_b=0;addr_b=3'd1; @(posedge clk);#1;
        if(dout_a!==8'hAA)begin $display("FAIL porta read");errors=errors+1;end
        if(dout_b!==8'hBB)begin $display("FAIL portb read");errors=errors+1;end
        if(errors==0) $display("PASS: True Dual-Port RAM test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
