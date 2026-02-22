// Mealy FSM – Sequence Detector for "1011"
// Overlapping detection; out=1 in the same clock cycle the last '1' arrives
module mealy_fsm_seq_detector (
    input  clk,
    input  rst_n,
    input  in,
    output reg out
);
    localparam S0 = 2'd0,  // initial
               S1 = 2'd1,  // got "1"
               S2 = 2'd2,  // got "10"
               S3 = 2'd3;  // got "101"

    reg [1:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    // Next-state and output (Mealy: output depends on state AND input)
    always @(*) begin
        out = 0;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S1 : S2;
            S2: next_state = in ? S3 : S0;
            S3: begin
                    if (in) begin out = 1; next_state = S1; end  // "1011" detected
                    else         next_state = S2;
                end
            default: next_state = S0;
        endcase
    end
endmodule
