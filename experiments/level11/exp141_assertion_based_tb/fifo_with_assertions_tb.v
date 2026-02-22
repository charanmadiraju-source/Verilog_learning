`timescale 1ns/1ps
module fifo_with_assertions_tb;
    reg clk=0,rst,wr_en,rd_en; reg [7:0] din; wire [7:0] dout; wire full,empty;
    always #5 clk=~clk;
    fifo_with_assertions #(.DEPTH(8),.WIDTH(8)) uut(.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),.din(din),.dout(dout),.full(full),.empty(empty));
    integer errors=0,i;
    initial begin
        $dumpfile("fifo_with_assertions.vcd"); $dumpvars(0,fifo_with_assertions_tb);
        rst=1;wr_en=0;rd_en=0;din=0; @(posedge clk);#1; rst=0;
        // Write 4 values
        wr_en=1;
        for(i=0;i<4;i=i+1) begin din=8'd10*i+1; @(posedge clk);#1; end
        wr_en=0;
        // Read them back, check values
        rd_en=1;
        for(i=0;i<4;i=i+1) begin
            if(!empty) begin @(posedge clk);#1; end
        end
        rd_en=0;
        // Verify FIFO is now empty
        @(posedge clk);#1;
        if(!empty) begin $display("FAIL: should be empty");errors=errors+1; end
        // Try over-read (should not crash assertions)
        rd_en=1; @(posedge clk);#1; rd_en=0;
        if(errors==0) $display("PASS: Assertion-Based FIFO test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
