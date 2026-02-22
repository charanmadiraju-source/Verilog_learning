// Experiment 76: Traffic Light with Pedestrian Button
// When pedestrian button pressed during GREEN, transitions to YELLOW then RED+WALK.
// Inputs : clk, rst, ped_btn
// Outputs: red, yellow, green, walk
module traffic_light_ped #(
    parameter RED_TIME=4, GREEN_TIME=6, YELLOW_TIME=2, WALK_TIME=4
) (
    input  clk, rst, ped_btn,
    output red, yellow, green, walk
);
    localparam S_RED=2'd0, S_GREEN=2'd1, S_YELLOW=2'd2, S_WALK=2'd3;
    reg [1:0] state;
    reg [3:0] timer;
    reg       ped_req;
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=S_RED; timer<=0; ped_req<=0; end
        else begin
            if (ped_btn) ped_req <= 1;
            timer <= timer + 1;
            case (state)
                S_RED:    if(timer>=RED_TIME-1)    begin state<=S_GREEN;  timer<=0; end
                S_GREEN:  if(ped_req && timer>=1)  begin state<=S_YELLOW; timer<=0; ped_req<=0; end
                          else if(timer>=GREEN_TIME-1) begin state<=S_YELLOW; timer<=0; end
                S_YELLOW: if(timer>=YELLOW_TIME-1) begin state<=S_WALK;   timer<=0; end
                S_WALK:   if(timer>=WALK_TIME-1)   begin state<=S_RED;    timer<=0; end
                default:  begin state<=S_RED; timer<=0; end
            endcase
        end
    end
    assign red    = (state==S_RED  || state==S_WALK);
    assign green  = (state==S_GREEN);
    assign yellow = (state==S_YELLOW);
    assign walk   = (state==S_WALK);
endmodule
