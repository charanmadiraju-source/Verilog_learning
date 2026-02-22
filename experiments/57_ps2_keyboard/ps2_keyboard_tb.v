// PS/2 Keyboard Testbench
`timescale 1ns/1ps
module ps2_keyboard_tb;
    reg  clk, rst_n;
    reg  ps2_clk, ps2_data;
    wire [7:0] scan_code;
    wire valid;

    ps2_keyboard uut (.clk(clk),.rst_n(rst_n),.ps2_clk(ps2_clk),
                      .ps2_data(ps2_data),.scan_code(scan_code),.valid(valid));

    always #5 clk = ~clk;

    // Task: send one PS/2 bit on falling edge
    task send_ps2_bit;
        input b;
        begin
            ps2_data = b; #100;
            ps2_clk  = 0; #200;
            ps2_clk  = 1; #100;
        end
    endtask

    // Task: send a full PS/2 frame for byte 0x1C (scan code for 'A')
    task send_byte;
        input [7:0] data;
        integer i;
        reg parity;
        begin
            parity = 1; // odd parity
            for (i=0; i<8; i=i+1) parity = parity ^ data[i];
            send_ps2_bit(0);             // start
            for (i=0; i<8; i=i+1)
                send_ps2_bit(data[i]);   // data LSB first
            send_ps2_bit(parity);        // parity
            send_ps2_bit(1);             // stop
        end
    endtask

    initial begin
        $dumpfile("ps2_keyboard.vcd");
        $dumpvars(0, ps2_keyboard_tb);
        clk=0; rst_n=0; ps2_clk=1; ps2_data=1; #50; rst_n=1;
        send_byte(8'h1C);  // 'A' make code
        @(posedge valid); #10;
        if (scan_code !== 8'h1C)
            $display("FAIL: scan_code=%h expected 1C", scan_code);
        $display("PS/2 scan code received: %h", scan_code);
        $display("PS/2 Keyboard test complete.");
        $finish;
    end
endmodule
