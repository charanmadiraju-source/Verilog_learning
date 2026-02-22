// Experiment 23: 2-bit Binary Multiplier
// Uses AND gates to form partial products, then adds them.
// Inputs : a[1:0], b[1:0]
// Output : product[3:0]
module multiplier_2bit (
    input  [1:0] a, b,
    output [3:0] product
);
    // Partial products
    wire pp0 = a[0] & b[0];
    wire pp1 = a[1] & b[0];
    wire pp2 = a[0] & b[1];
    wire pp3 = a[1] & b[1];
    // Sum
    wire c1;
    assign product[0] = pp0;
    assign {c1, product[1]} = pp1 + pp2;
    assign product[3:2] = pp3 + c1;
endmodule
