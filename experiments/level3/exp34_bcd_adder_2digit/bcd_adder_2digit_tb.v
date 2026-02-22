`timescale 1ns/1ps
module bcd_adder_2digit_tb;
    reg [7:0] a,b; reg cin; wire [7:0] sum; wire cout;
    bcd_adder_2digit uut(.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    integer errors=0;
    initial begin
        $dumpfile("bcd_adder_2digit.vcd"); $dumpvars(0,bcd_adder_2digit_tb);
        // 25 + 37 = 62
        a=8'h25;b=8'h37;cin=0;#10;
        if(cout!==0||sum!==8'h62) begin $display("FAIL 25+37 got %h",sum);errors=errors+1;end
        // 99 + 01 = 00 with carry
        a=8'h99;b=8'h01;cin=0;#10;
        if(cout!==1||sum!==8'h00) begin $display("FAIL 99+01 got cout=%b sum=%h",cout,sum);errors=errors+1;end
        // 48 + 25 = 73
        a=8'h48;b=8'h25;cin=0;#10;
        if(cout!==0||sum!==8'h73) begin $display("FAIL 48+25 got %h",sum);errors=errors+1;end
        if(errors==0) $display("PASS: 2-digit BCD Adder test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
