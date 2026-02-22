`timescale 1ns/1ps
module sync_fifo_tb;
    reg clk=0,rst,wr_en,rd_en; reg [7:0] din; wire [7:0] dout; wire full,empty;
    always #5 clk=~clk;
    sync_fifo #(.DEPTH(8),.WIDTH(8)) uut(.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),.full(full),.empty(empty));
    integer errors=0;
    initial begin
        $dumpfile("sync_fifo.vcd"); $dumpvars(0,sync_fifo_tb);
        rst=1;wr_en=0;rd_en=0; @(posedge clk);#1; rst=0;
        if(empty!==1)begin $display("FAIL not empty after reset");errors=errors+1;end
        // Write 3 values
        wr_en=1;din=8'hAA; @(posedge clk);#1;
        din=8'hBB; @(posedge clk);#1;
        din=8'hCC; @(posedge clk);#1; wr_en=0;
        // Read back
        if(dout!==8'hAA)begin $display("FAIL read AA got %h",dout);errors=errors+1;end
        rd_en=1; @(posedge clk);#1;
        if(dout!==8'hBB)begin $display("FAIL read BB got %h",dout);errors=errors+1;end
        @(posedge clk);#1;
        if(dout!==8'hCC)begin $display("FAIL read CC got %h",dout);errors=errors+1;end
        @(posedge clk);#1; rd_en=0;
        if(empty!==1)begin $display("FAIL not empty");errors=errors+1;end
        if(errors==0) $display("PASS: Sync FIFO test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
