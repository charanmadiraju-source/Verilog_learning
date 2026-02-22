// Experiment 50: 8-bit Register (Parallel Load)
// Loads d when load=1; holds when load=0. Reset clears.
// Inputs : clk, rst, load, d[7:0]
// Output : q[7:0]
module register_8bit (
    input        clk, rst, load,
    input  [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk) begin
        if      (rst)  q <= 8'b0;
        else if (load) q <= d;
    end
endmodule
