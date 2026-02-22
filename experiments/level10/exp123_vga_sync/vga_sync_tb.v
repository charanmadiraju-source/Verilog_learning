`timescale 1ns/1ps
module vga_sync_tb;
    reg clk=0,rst; wire hsync,vsync,display_on; wire [9:0] h_count,v_count;
    always #20 clk=~clk; // ~25 MHz
    vga_sync uut(.clk(clk),.rst(rst),.hsync(hsync),.vsync(vsync),.display_on(display_on),.h_count(h_count),.v_count(v_count));
    integer errors=0;
    initial begin
        $dumpfile("vga_sync.vcd"); $dumpvars(0,vga_sync_tb);
        rst=1; #100; rst=0;
        // Run for 2 full lines (800 pixels each)
        repeat(1600) @(posedge clk); #1;
        // Check h_count is in range 0..799
        if(h_count > 799) begin $display("FAIL h_count=%0d",h_count);errors=errors+1;end
        // display_on should be 0 now (past line 0 in v)
        if(errors==0) $display("PASS: VGA Sync Generator test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
