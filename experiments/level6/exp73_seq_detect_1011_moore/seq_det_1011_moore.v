// Experiment 73: Sequence Detector "1011" (Non-overlapping, Moore)
// After detection, always returns to IDLE.
// Inputs : clk, rst, in
// Output : detected
module seq_det_1011_moore (
    input  clk, rst, in,
    output reg detected
);
    localparam IDLE=3'd0, S1=3'd1, S10=3'd2, S101=3'd3, S1011=3'd4;
    reg [2:0] state;
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else case (state)
            IDLE:  state <= in ? S1 : IDLE;
            S1:    state <= in ? S1 : S10;
            S10:   state <= in ? S101 : IDLE;
            S101:  state <= in ? S1011 : S10;
            S1011: state <= IDLE;
            default: state <= IDLE;
        endcase
    end
    always @(*) detected = (state == S1011);
endmodule
