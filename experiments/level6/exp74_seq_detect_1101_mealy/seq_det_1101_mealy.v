// Experiment 74: Sequence Detector "1101" (Mealy)
// Output is combinational, depends on current state and input.
// Faster response than Moore.
// Inputs : clk, rst, in
// Output : detected (combinational)
module seq_det_1101_mealy (
    input  clk, rst, in,
    output detected
);
    localparam IDLE=2'd0, S1=2'd1, S11=2'd2, S110=2'd3;
    reg [1:0] state;
    always @(posedge clk or posedge rst) begin
        if (rst) state <= IDLE;
        else case (state)
            IDLE: state <= in ? S1 : IDLE;
            S1:   state <= in ? S11 : IDLE;
            S11:  state <= in ? S11 : S110;
            S110: state <= in ? IDLE : IDLE;
            default: state <= IDLE;
        endcase
    end
    // Mealy: output when in S110 and in=1
    assign detected = (state == S110) && in;
endmodule
