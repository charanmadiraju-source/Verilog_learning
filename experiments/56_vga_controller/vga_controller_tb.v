// VGA Controller Testbench
`timescale 1ns/1ps
module vga_controller_tb;
    reg  pclk, rst_n;
    wire hsync, vsync, h_active, v_active;
    wire [9:0] h_count, v_count;

    vga_controller uut (
        .pclk(pclk),.rst_n(rst_n),.hsync(hsync),.vsync(vsync),
        .h_active(h_active),.v_active(v_active),
        .h_count(h_count),.v_count(v_count)
    );

    always #20 pclk = ~pclk;  // 25 MHz -> 40 ns period

    integer hsync_cnt = 0, vsync_cnt = 0;
    reg     prev_hsync = 1, prev_vsync = 1;

    always @(negedge hsync) hsync_cnt = hsync_cnt + 1;
    always @(negedge vsync) vsync_cnt = vsync_cnt + 1;

    initial begin
        $dumpfile("vga_controller.vcd");
        $dumpvars(0, vga_controller_tb);
        pclk=0; rst_n=0; #50; rst_n=1;
        // Simulate 2 full frames: 2 * 525 * 800 = 840000 pixel clocks
        #(840000 * 40);
        if (hsync_cnt < 1040 || hsync_cnt > 1060)
            $display("FAIL: hsync count=%0d expected ~1050", hsync_cnt);
        if (vsync_cnt < 1 || vsync_cnt > 3)
            $display("FAIL: vsync count=%0d expected 2", vsync_cnt);
        $display("VGA: hsync_pulses=%0d vsync_pulses=%0d", hsync_cnt, vsync_cnt);
        $display("VGA Controller test complete.");
        $finish;
    end
endmodule
