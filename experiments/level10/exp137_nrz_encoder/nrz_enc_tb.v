`timescale 1ns/1ps
module nrz_enc_tb;
    reg clk=0,rst,data_in,data_valid; wire nrz_out,stuff_inserted;
    always #5 clk=~clk;
    nrz_enc uut(.clk(clk),.rst(rst),.data_in(data_in),.data_valid(data_valid),.nrz_out(nrz_out),.stuff_inserted(stuff_inserted));
    integer errors=0,i;
    initial begin
        $dumpfile("nrz_enc.vcd"); $dumpvars(0,nrz_enc_tb);
        rst=1; @(posedge clk);#1; rst=0;
        data_valid=1;
        // Send 5 ones
        for(i=0;i<5;i=i+1)begin data_in=1; @(posedge clk);#1;
            if(stuff_inserted)begin $display("FAIL early stuff at i=%0d",i);errors=errors+1;end
        end
        // Send 6th one -> stuff should be inserted
        data_in=1; @(posedge clk);#1;
        if(!stuff_inserted)begin $display("FAIL no stuff after 5 ones");errors=errors+1;end
        if(nrz_out!==0)begin $display("FAIL stuffed bit not 0");errors=errors+1;end
        if(errors==0) $display("PASS: NRZ Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
