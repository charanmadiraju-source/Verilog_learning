// Experiment 75: Traffic Light Controller (4 states, timed)
// Uses small timer values for simulation speed.
// RED->GREEN->YELLOW->RED cycle.
// Inputs : clk, rst
// Outputs: red, yellow, green
module traffic_light #(
    parameter RED_TIME=4, GREEN_TIME=3, YELLOW_TIME=2
) (
    input  clk, rst,
    output red, yellow, green
);
    localparam S_RED=2'd0, S_GREEN=2'd1, S_YELLOW=2'd2;
    reg [1:0] state;
    reg [3:0] timer;
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=S_RED; timer<=0; end
        else begin
            timer <= timer + 1;
            case (state)
                S_RED:    if(timer>=RED_TIME-1)    begin state<=S_GREEN;  timer<=0; end
                S_GREEN:  if(timer>=GREEN_TIME-1)  begin state<=S_YELLOW; timer<=0; end
                S_YELLOW: if(timer>=YELLOW_TIME-1) begin state<=S_RED;    timer<=0; end
                default:  begin state<=S_RED; timer<=0; end
            endcase
        end
    end
    assign red    = (state==S_RED);
    assign green  = (state==S_GREEN);
    assign yellow = (state==S_YELLOW);
endmodule
