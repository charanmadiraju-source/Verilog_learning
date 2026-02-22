// Experiment 124: PWM Controller
// Generates PWM signal with configurable period and duty cycle.
// Inputs : clk, rst, duty[7:0] (0-255 = 0-100%), period[7:0]
// Output : pwm_out
module pwm_ctrl (
    input        clk, rst,
    input  [7:0] duty, period,
    output       pwm_out
);
    reg [7:0] counter;
    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 0;
        else if (counter >= period-1) counter <= 0;
        else counter <= counter + 1;
    end
    assign pwm_out = (counter < duty);
endmodule
