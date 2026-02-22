// Experiment 59: 4-bit Counter with Load and Enable
// Priority: rst > load > en > hold
// Inputs : clk, rst, load, en, d[3:0]
// Output : count[3:0]
module counter_load_en (
    input        clk, rst, load, en,
    input  [3:0] d,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if      (rst)  count <= 4'b0;
        else if (load) count <= d;
        else if (en)   count <= count + 1'b1;
    end
endmodule
