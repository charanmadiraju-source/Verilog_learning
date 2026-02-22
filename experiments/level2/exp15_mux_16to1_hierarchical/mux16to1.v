// Experiment 15: 16-to-1 Multiplexer (Hierarchical)
// Builds a 16-to-1 MUX from four 4-to-1 MUX instances plus one 4-to-1 for final stage.
// Demonstrates hierarchical design and module reuse.
// Inputs : d[15:0], sel[3:0]
// Output : y
module mux4to1_h (
    input  d0, d1, d2, d3,
    input  [1:0] sel,
    output y
);
    assign y = (sel == 2'b00) ? d0 :
               (sel == 2'b01) ? d1 :
               (sel == 2'b10) ? d2 : d3;
endmodule

module mux16to1 (
    input  [15:0] d,
    input  [3:0]  sel,
    output y
);
    wire [3:0] stage1;
    mux4to1_h m0 (.d0(d[0]),.d1(d[1]),.d2(d[2]),.d3(d[3]),  .sel(sel[1:0]),.y(stage1[0]));
    mux4to1_h m1 (.d0(d[4]),.d1(d[5]),.d2(d[6]),.d3(d[7]),  .sel(sel[1:0]),.y(stage1[1]));
    mux4to1_h m2 (.d0(d[8]),.d1(d[9]),.d2(d[10]),.d3(d[11]),.sel(sel[1:0]),.y(stage1[2]));
    mux4to1_h m3 (.d0(d[12]),.d1(d[13]),.d2(d[14]),.d3(d[15]),.sel(sel[1:0]),.y(stage1[3]));
    mux4to1_h m4 (.d0(stage1[0]),.d1(stage1[1]),.d2(stage1[2]),.d3(stage1[3]),.sel(sel[3:2]),.y(y));
endmodule
