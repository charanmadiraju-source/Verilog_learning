`timescale 1ns/1ps
module parity_gen_tb;
    reg [3:0] data; wire even_parity, odd_parity;
    parity_gen uut(.data(data),.even_parity(even_parity),.odd_parity(odd_parity));
    integer i, errors=0;
    initial begin
        $dumpfile("parity_gen.vcd"); $dumpvars(0,parity_gen_tb);
        for(i=0;i<16;i=i+1) begin
            data=i[3:0]; #10;
            if(even_parity !== ^data) begin $display("FAIL even i=%0d",i); errors=errors+1; end
            if(odd_parity  !== ~(^data)) begin $display("FAIL odd i=%0d",i); errors=errors+1; end
        end
        if(errors==0) $display("PASS: Parity Generator test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
