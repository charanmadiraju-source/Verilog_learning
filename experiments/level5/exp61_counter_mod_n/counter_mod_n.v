// Experiment 61: Modulo-N Counter
// Counts 0..N-1 then resets. Non-power-of-2 moduli supported.
// Parameter: N (default 10)
// Inputs : clk, rst
// Outputs: count[3:0], tc (terminal count)
module counter_mod_n #(parameter N=10) (
    input  clk, rst,
    output reg [3:0] count,
    output tc
);
    always @(posedge clk or posedge rst) begin
        if (rst || count == N-1) count <= 4'b0;
        else                     count <= count + 1'b1;
    end
    assign tc = (count == N-1);
endmodule
