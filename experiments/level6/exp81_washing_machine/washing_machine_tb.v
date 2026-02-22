`timescale 1ns/1ps
module washing_machine_tb;
    reg clk=0,rst,start; wire fill,wash,rinse,spin,done;
    always #5 clk=~clk;
    washing_machine #(.FILL_T(3),.WASH_T(4),.RINSE_T(3),.SPIN_T(2)) uut(
        .clk(clk),.rst(rst),.start(start),.fill(fill),.wash(wash),.rinse(rinse),.spin(spin),.done(done));
    integer errors=0;
    initial begin
        $dumpfile("washing_machine.vcd"); $dumpvars(0,washing_machine_tb);
        rst=1;start=0; @(posedge clk);#1; rst=0;
        start=1; @(posedge clk);#1; start=0;
        if(fill!==1)begin $display("FAIL fill");errors=errors+1;end
        repeat(3) @(posedge clk);#1;
        if(wash!==1)begin $display("FAIL wash");errors=errors+1;end
        repeat(4) @(posedge clk);#1;
        if(rinse!==1)begin $display("FAIL rinse");errors=errors+1;end
        repeat(3) @(posedge clk);#1;
        if(spin!==1)begin $display("FAIL spin");errors=errors+1;end
        repeat(2) @(posedge clk);#1;
        if(done!==1)begin $display("FAIL done");errors=errors+1;end
        if(errors==0) $display("PASS: Washing Machine test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
