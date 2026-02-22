// Experiment 31: 4-bit Subtractor using 2's Complement
// Reuses adder logic: diff = a + (~b) + 1.
// Inputs : a[3:0], b[3:0]
// Outputs: diff[3:0], borrow (borrow=1 when a<b)
module subtractor_4bit (
    input  [3:0] a, b,
    output [3:0] diff,
    output       borrow
);
    wire cout;
    assign {cout, diff} = {1'b0,a} + {1'b0,~b} + 5'd1;
    assign borrow = ~cout;
endmodule
