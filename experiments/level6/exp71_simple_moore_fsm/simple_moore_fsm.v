// Experiment 71: Simple Moore FSM (3 states)
// States: IDLE(0)->S1(1) on x=1; S1->S2(2) on x=1, S1->IDLE on x=0;
//         S2->IDLE always. Output y=1 in S2.
// Inputs : clk, rst, x
// Output : y
module simple_moore_fsm (
    input  clk, rst, x,
    output reg y
);
    localparam IDLE=2'd0, S1=2'd1, S2=2'd2;
    reg [1:0] state;
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else case (state)
            IDLE: state <= x ? S1 : IDLE;
            S1:   state <= x ? S2 : IDLE;
            S2:   state <= IDLE;
            default: state <= IDLE;
        endcase
    end
    always @(*) y = (state == S2);
endmodule
