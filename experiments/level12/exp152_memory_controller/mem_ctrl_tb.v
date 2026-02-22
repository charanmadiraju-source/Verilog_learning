`timescale 1ns/1ps
module mem_ctrl_tb;
    reg clk=0,rst,req,we; reg [7:0] addr,wdata; wire [7:0] rdata; wire ack; wire [1:0] cmd;
    always #5 clk=~clk;
    mem_ctrl uut(.clk(clk),.rst(rst),.req(req),.we(we),.addr(addr),.wdata(wdata),.rdata(rdata),.ack(ack),.cmd(cmd));
    integer errors=0;
    reg saw_ack;
    initial begin
        $dumpfile("mem_ctrl.vcd"); $dumpvars(0,mem_ctrl_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // Read: addr=5 (mem initialized to i)
        req=1;we=0;addr=8'd5;wdata=0; saw_ack=0;
        repeat(10) begin @(posedge clk);#1; if(ack) begin saw_ack=1; if(rdata!==8'd5)begin $display("FAIL rdata=%0d",rdata);errors=errors+1;end end end
        req=0;
        if(!saw_ack)begin $display("FAIL no ack for read");errors=errors+1;end
        // Write then read back
        @(posedge clk);#1; req=1;we=1;addr=8'd10;wdata=8'hAB; saw_ack=0;
        repeat(10) begin @(posedge clk);#1; if(ack) saw_ack=1; end
        req=0; we=0;
        if(!saw_ack)begin $display("FAIL no ack for write");errors=errors+1;end
        // Read back
        repeat(5) begin @(posedge clk);#1; end
        req=1;we=0;addr=8'd10; saw_ack=0;
        repeat(10) begin @(posedge clk);#1; if(ack) begin saw_ack=1; if(rdata!==8'hAB)begin $display("FAIL readback=%0d",rdata);errors=errors+1;end end end
        req=0;
        if(errors==0) $display("PASS: Memory Controller test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
