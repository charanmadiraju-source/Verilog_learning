// Experiment 52: 8-bit Shift Register (Parallel In, Serial Out - PISO)
// Load parallel data when load=1; shift out serially when load=0.
// Inputs : clk, rst, load, parallel_in[7:0]
// Output : sout
module piso_8bit (
    input        clk, rst, load,
    input  [7:0] parallel_in,
    output       sout
);
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        if      (rst)  shift_reg <= 8'b0;
        else if (load) shift_reg <= parallel_in;
        else           shift_reg <= {shift_reg[6:0], 1'b0};
    end
    assign sout = shift_reg[7];
endmodule
