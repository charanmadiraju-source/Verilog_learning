// 4-Bit Magnitude Comparator
// Outputs: gt (a>b), eq (a==b), lt (a<b)
module comparator_4bit (
    input  [3:0] a,
    input  [3:0] b,
    output gt,
    output eq,
    output lt
);
    assign gt = (a > b);
    assign eq = (a == b);
    assign lt = (a < b);
endmodule
