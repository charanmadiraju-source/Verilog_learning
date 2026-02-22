// Moore FSM – Sequence Detector for "101"
// Overlapping detection; out=1 for one clock when "101" is detected
module moore_fsm_seq_detector (
    input  clk,
    input  rst_n,
    input  in,
    output reg out
);
    // State encoding
    localparam S0 = 2'd0,  // initial / no progress
               S1 = 2'd1,  // received "1"
               S2 = 2'd2,  // received "10"
               S3 = 2'd3;  // received "101" -> output 1

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S1 : S2;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic (Moore: depends only on state)
    always @(*) begin
        out = (state == S3);
    end
endmodule
