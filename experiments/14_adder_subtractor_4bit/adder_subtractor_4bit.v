// 4-Bit Adder-Subtractor
// mode=0 -> add (sum = a + b + cin)
// mode=1 -> subtract (sum = a - b = a + ~b + 1)
module adder_subtractor_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        mode,   // 0=add, 1=subtract
    output [3:0] result,
    output       cout
);
    wire [3:0] b_xor;
    assign b_xor = b ^ {4{mode}};           // invert b when subtracting
    assign {cout, result} = a + b_xor + mode; // +mode acts as +1 for 2's complement
endmodule
