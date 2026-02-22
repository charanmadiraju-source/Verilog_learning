`timescale 1ns/1ps
module manchester_enc_tb;
    reg clk=0,rst,data_in,data_valid; wire manchester_out;
    always #5 clk=~clk;
    manchester_enc uut(.clk(clk),.rst(rst),.data_in(data_in),.data_valid(data_valid),.manchester_out(manchester_out));
    integer errors=0;
    initial begin
        $dumpfile("manchester_enc.vcd"); $dumpvars(0,manchester_enc_tb);
        rst=1; @(posedge clk);#1; rst=0;
        data_valid=1;
        // Encode '1': first half=0, second half=1
        data_in=1; @(posedge clk);#1;
        if(manchester_out!==0)begin $display("FAIL bit1 first_half=%b",manchester_out);errors=errors+1;end
        @(posedge clk);#1;
        if(manchester_out!==1)begin $display("FAIL bit1 second_half=%b",manchester_out);errors=errors+1;end
        // Encode '0': first half=1, second half=0
        data_in=0; @(posedge clk);#1;
        if(manchester_out!==1)begin $display("FAIL bit0 first_half=%b",manchester_out);errors=errors+1;end
        @(posedge clk);#1;
        if(manchester_out!==0)begin $display("FAIL bit0 second_half=%b",manchester_out);errors=errors+1;end
        if(errors==0) $display("PASS: Manchester Encoder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
