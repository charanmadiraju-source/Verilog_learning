// Experiment 9: Full Adder (Dataflow)
// Implements the full adder using Boolean equations and assign statements.
// sum  = a ^ b ^ cin
// cout = (a & b) | (b & cin) | (a & cin)
// Inputs : a, b, cin
// Outputs: sum, cout
module full_adder_dataflow (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
