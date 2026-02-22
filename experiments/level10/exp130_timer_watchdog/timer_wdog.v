// Experiment 130: Timer with Watchdog
// Programmable countdown timer; if not reloaded in time, watchdog fires.
// Inputs : clk, rst, load, timer_val[7:0], kick_wdog
// Outputs: timer_done, wdog_rst
module timer_wdog (
    input        clk, rst, load, kick_wdog,
    input  [7:0] timer_val,
    output reg   timer_done, wdog_rst
);
    reg [7:0] timer_cnt, wdog_cnt;
    parameter WDOG_TIMEOUT = 8'd20;
    always @(posedge clk or posedge rst) begin
        if (rst) begin timer_cnt<=0;timer_done<=0;wdog_cnt<=0;wdog_rst<=0; end
        else begin
            timer_done<=0; wdog_rst<=0;
            // Timer
            if (load) timer_cnt<=timer_val;
            else if (timer_cnt > 0) begin
                timer_cnt<=timer_cnt-1;
                if (timer_cnt==1) timer_done<=1;
            end
            // Watchdog
            if (kick_wdog) wdog_cnt<=0;
            else begin
                wdog_cnt<=wdog_cnt+1;
                if (wdog_cnt==WDOG_TIMEOUT-1) wdog_rst<=1;
            end
        end
    end
endmodule
