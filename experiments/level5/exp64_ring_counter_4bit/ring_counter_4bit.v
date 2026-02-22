// Experiment 64: 4-bit Ring Counter
// Single hot bit circulates: 1000->0100->0010->0001->1000...
// (right rotation each clock cycle)
// Inputs : clk, rst
// Output : q[3:0]
module ring_counter_4bit (
    input  clk, rst,
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b1000;
        else     q <= {q[0], q[3:1]};  // right rotation
    end
endmodule
