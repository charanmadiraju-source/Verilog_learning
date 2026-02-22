// Experiment 10: Full Adder (Behavioral)
// Uses an always @(*) combinational block.
// Demonstrates behavioral modeling with procedural assignment.
// Inputs : a, b, cin
// Outputs: sum, cout
module full_adder_behavioral (
    input  a,
    input  b,
    input  cin,
    output reg sum,
    output reg cout
);
    always @(*) begin
        {cout, sum} = a + b + cin;
    end
endmodule
