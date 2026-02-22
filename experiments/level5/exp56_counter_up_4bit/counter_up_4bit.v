// Experiment 56: 4-bit Binary Up Counter (Async Reset)
// Counts 0..15 and wraps. rst is asynchronous, active-high.
// Inputs : clk, rst
// Output : count[3:0]
module counter_up_4bit (
    input  clk, rst,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) count <= 4'b0;
        else     count <= count + 1'b1;
    end
endmodule
