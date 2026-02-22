// Experiment 72: Sequence Detector "101" (Overlapping, Moore)
// After detecting 101, overlap: stays in S1 if input=1.
// Inputs : clk, rst, in
// Output : detected
module seq_det_101_moore (
    input  clk, rst, in,
    output reg detected
);
    localparam IDLE=2'd0, S1=2'd1, S10=2'd2, S101=2'd3;
    reg [1:0] state;
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else case (state)
            IDLE: state <= in ? S1 : IDLE;
            S1:   state <= in ? S1 : S10;
            S10:  state <= in ? S101 : IDLE;
            S101: state <= in ? S1 : S10;
            default: state <= IDLE;
        endcase
    end
    always @(*) detected = (state == S101);
endmodule
