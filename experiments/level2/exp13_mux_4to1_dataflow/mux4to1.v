// Experiment 13: 4-to-1 Multiplexer (Dataflow)
// Uses nested ternary operators and a 2-bit select vector.
// Inputs : d0, d1, d2, d3, sel[1:0]
// Output : y
module mux4to1 (
    input  d0, d1, d2, d3,
    input  [1:0] sel,
    output y
);
    assign y = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 : d3;
endmodule
