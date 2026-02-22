// Experiment 42: D Latch (Level-Sensitive)
// Transparent when en=1; holds value when en=0.
// Inputs : d, en
// Output : q
module d_latch (
    input  d, en,
    output reg q
);
    always @(*) begin
        if (en) q = d;
    end
endmodule
