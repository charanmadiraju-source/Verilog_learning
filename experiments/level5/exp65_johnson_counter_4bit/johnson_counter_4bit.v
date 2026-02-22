// Experiment 65: 4-bit Johnson Counter
// Complement feedback: 8 unique states, twisted ring.
// Inputs : clk, rst
// Output : q[3:0]
module johnson_counter_4bit (
    input  clk, rst,
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b0000;
        else     q <= {q[2:0], ~q[3]};
    end
endmodule
