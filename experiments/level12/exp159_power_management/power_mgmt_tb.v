`timescale 1ns/1ps
module power_mgmt_tb;
    reg clk=0,rst,we;reg[1:0]reg_addr;reg[7:0]wr_data;reg[3:0]wakeup_req;
    wire[7:0]rd_data;wire[3:0]clk_en,pwr_gate;
    always #5 clk=~clk;
    power_mgmt uut(.clk(clk),.rst(rst),.we(we),.reg_addr(reg_addr),.wr_data(wr_data),.wakeup_req(wakeup_req),.rd_data(rd_data),.clk_en(clk_en),.pwr_gate(pwr_gate));
    integer errors=0;
    initial begin
        $dumpfile("power_mgmt.vcd");$dumpvars(0,power_mgmt_tb);
        rst=1;we=0;wakeup_req=0;@(posedge clk);#1;rst=0;
        // Enable domain 1
        we=1;reg_addr=0;wr_data=8'h03;@(posedge clk);#1;we=0;
        @(posedge clk);#1;
        if(clk_en!==4'b0011)begin $display("FAIL clk_en=%b",clk_en);errors=errors+1;end
        // Wakeup domain 3
        wakeup_req=4'b1000;@(posedge clk);#1;wakeup_req=0;@(posedge clk);#1;
        if(clk_en[3]!==1)begin $display("FAIL wakeup");errors=errors+1;end
        if(errors==0)$display("PASS: Power Management test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
