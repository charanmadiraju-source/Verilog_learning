// PWM Generator
// duty_cycle / PERIOD determines the on-time fraction
module pwm_generator #(
    parameter PERIOD = 100
)(
    input        clk,
    input        rst_n,
    input  [$clog2(PERIOD)-1:0] duty_cycle,  // 0 to PERIOD
    output reg   pwm_out
);
    reg [$clog2(PERIOD)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            if (counter == PERIOD - 1)
                counter <= 0;
            else
                counter <= counter + 1'b1;

            pwm_out <= (counter < duty_cycle);
        end
    end
endmodule
