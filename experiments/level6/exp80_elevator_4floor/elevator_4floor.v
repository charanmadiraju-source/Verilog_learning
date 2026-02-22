// Experiment 80: Elevator Controller (4-floor)
// Moves one floor per cycle toward nearest pending request.
// Inputs : clk, rst, req[3:0]
// Outputs: current_floor[1:0], door_open
module elevator_4floor (
    input       clk, rst,
    input [3:0] req,
    output reg [1:0] current_floor,
    output reg       door_open
);
    reg [3:0] pending;
    always @(posedge clk or posedge rst) begin
        if (rst) begin current_floor<=0; door_open<=0; pending<=0; end
        else begin
            pending <= pending | req;
            door_open <= 0;
            if (pending[current_floor]) begin
                door_open <= 1;
                case(current_floor)
                    2'd0: pending[0] <= 0;
                    2'd1: pending[1] <= 0;
                    2'd2: pending[2] <= 0;
                    2'd3: pending[3] <= 0;
                endcase
            end else if (|pending) begin
                // Check if any pending floor is above
                if ((current_floor < 3) &&
                    ((current_floor==2'd0 && (pending[1]||pending[2]||pending[3])) ||
                     (current_floor==2'd1 && (pending[2]||pending[3])) ||
                     (current_floor==2'd2 && pending[3])))
                    current_floor <= current_floor + 1;
                else if (current_floor > 0)
                    current_floor <= current_floor - 1;
            end
        end
    end
endmodule
