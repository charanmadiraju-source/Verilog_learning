// Half Subtractor Testbench
`timescale 1ns/1ps
module half_subtractor_tb;
    reg  a, b;
    wire diff, borrow;

    half_subtractor uut (.a(a), .b(b), .diff(diff), .borrow(borrow));

    initial begin
        $dumpfile("half_subtractor.vcd");
        $dumpvars(0, half_subtractor_tb);
        {a,b}=2'b00; #10; if(diff!==0||borrow!==0) $display("FAIL 00");
        {a,b}=2'b01; #10; if(diff!==1||borrow!==1) $display("FAIL 01");
        {a,b}=2'b10; #10; if(diff!==1||borrow!==0) $display("FAIL 10");
        {a,b}=2'b11; #10; if(diff!==0||borrow!==0) $display("FAIL 11");
        $display("Half subtractor test complete.");
        $finish;
    end
endmodule
