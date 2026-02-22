// Experiment 57: 4-bit Binary Down Counter (Async Reset)
// Counts 15..0 and wraps. rst loads all-ones.
// Inputs : clk, rst
// Output : count[3:0]
module counter_down_4bit (
    input  clk, rst,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) count <= 4'hF;
        else     count <= count - 1'b1;
    end
endmodule
