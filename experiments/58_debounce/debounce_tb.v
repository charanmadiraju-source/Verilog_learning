// Debounce Testbench
`timescale 1ns/1ps
module debounce_tb;
    reg  clk, rst_n, noisy;
    wire stable;

    debounce #(.STABLE_CYCLES(10)) uut (.clk(clk),.rst_n(rst_n),.noisy(noisy),.stable(stable));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("debounce.vcd");
        $dumpvars(0, debounce_tb);
        clk=0; rst_n=0; noisy=0; #12; rst_n=1;
        // Simulate bounce: rapid toggles
        noisy=1; #20; noisy=0; #10; noisy=1; #15; noisy=0; #8; noisy=1;
        // Hold stable for 10+ cycles
        repeat(15) @(posedge clk);
        if (stable!==1) $display("FAIL: expected stable=1 after settling");
        // Release
        noisy=0;
        repeat(15) @(posedge clk);
        if (stable!==0) $display("FAIL: expected stable=0 after release");
        $display("Debounce test complete.");
        $finish;
    end
endmodule
