// Experiment 79: Elevator Controller (2-floor)
// Moves toward requested floor and opens door when arrived.
// Inputs : clk, rst, req_floor0 (ground), req_floor1 (upper)
// Outputs: floor (0=ground, 1=upper), door_open
module elevator_2floor (
    input  clk, rst, req_floor0, req_floor1,
    output reg floor,
    output reg door_open
);
    localparam IDLE=2'd0, MOVING_UP=2'd1, MOVING_DOWN=2'd2, DOOR=2'd3;
    reg [1:0] state;
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE; floor<=0; door_open<=0; end
        else case (state)
            IDLE: begin
                door_open <= 0;
                if      (req_floor1 && floor==0) state<=MOVING_UP;
                else if (req_floor0 && floor==1) state<=MOVING_DOWN;
            end
            MOVING_UP:   begin floor<=1; state<=DOOR; end
            MOVING_DOWN: begin floor<=0; state<=DOOR; end
            DOOR:        begin door_open<=1; state<=IDLE; end
        endcase
    end
endmodule
