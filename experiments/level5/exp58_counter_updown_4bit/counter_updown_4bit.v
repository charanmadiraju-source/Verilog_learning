// Experiment 58: 4-bit Up/Down Counter with Direction Control
// up=1: counts up; up=0: counts down.
// Inputs : clk, rst, up
// Output : count[3:0]
module counter_updown_4bit (
    input  clk, rst, up,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) count <= 4'b0;
        else if (up) count <= count + 1'b1;
        else         count <= count - 1'b1;
    end
endmodule
