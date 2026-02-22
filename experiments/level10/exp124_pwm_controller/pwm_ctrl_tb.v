`timescale 1ns/1ps
module pwm_ctrl_tb;
    reg clk=0,rst; reg [7:0] duty,period; wire pwm_out;
    always #5 clk=~clk;
    pwm_ctrl uut(.clk(clk),.rst(rst),.duty(duty),.period(period),.pwm_out(pwm_out));
    integer high_cnt, total_cnt, errors=0;
    initial begin
        $dumpfile("pwm_ctrl.vcd"); $dumpvars(0,pwm_ctrl_tb);
        rst=1; @(posedge clk);#1; rst=0;
        // 50% duty: duty=128, period=255
        duty=8'd128; period=8'd255;
        high_cnt=0; total_cnt=255;
        repeat(255) begin @(posedge clk);#1; if(pwm_out) high_cnt=high_cnt+1; end
        // Should be ~50%: 127 or 128
        if(high_cnt < 125 || high_cnt > 130) begin
            $display("FAIL 50%% duty: high_cnt=%0d/255",high_cnt);errors=errors+1;
        end
        // 0% duty
        duty=8'd0; repeat(10) @(posedge clk);#1;
        if(pwm_out!==0)begin $display("FAIL 0%% duty");errors=errors+1;end
        if(errors==0) $display("PASS: PWM Controller test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
