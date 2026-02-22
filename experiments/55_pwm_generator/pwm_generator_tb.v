// PWM Generator Testbench
`timescale 1ns/1ps
module pwm_generator_tb;
    reg  clk, rst_n;
    reg  [6:0] duty_cycle;  // 0-99 for PERIOD=100
    wire pwm_out;

    pwm_generator #(.PERIOD(100)) uut (
        .clk(clk),.rst_n(rst_n),.duty_cycle(duty_cycle),.pwm_out(pwm_out)
    );

    always #5 clk = ~clk;

    integer high_cnt, total;

    initial begin
        $dumpfile("pwm_generator.vcd");
        $dumpvars(0, pwm_generator_tb);
        clk=0; rst_n=0; duty_cycle=50; #12; rst_n=1;
        // Count high cycles over 100 clock periods
        high_cnt=0; total=0;
        repeat(100) begin
            @(posedge clk); #1;
            if (pwm_out) high_cnt = high_cnt + 1;
            total = total + 1;
        end
        $display("Duty: %0d%% -> high=%0d/%0d", duty_cycle, high_cnt, total);
        if (high_cnt < 45 || high_cnt > 55)
            $display("FAIL: duty cycle out of range");
        $display("PWM Generator test complete.");
        $finish;
    end
endmodule
