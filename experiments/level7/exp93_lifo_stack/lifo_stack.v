// Experiment 93: LIFO Stack (8-deep, 8-bit)
// Push adds element; Pop removes top element.
// Inputs : clk, rst, push, pop, din[7:0]
// Outputs: dout[7:0], full, empty, overflow, underflow
module lifo_stack #(parameter DEPTH=8, WIDTH=8) (
    input              clk, rst, push, pop,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    output             full, empty, overflow, underflow
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] sp; // stack pointer
    reg ov, un;
    always @(posedge clk or posedge rst) begin
        if (rst) begin sp<=0; ov<=0; un<=0; end
        else begin
            ov<=0; un<=0;
            if (push && !full)  begin mem[sp[($clog2(DEPTH)-1):0]] <= din; sp<=sp+1; end
            else if (push)      ov<=1;
            if (pop  && !empty) sp<=sp-1;
            else if (pop)       un<=1;
        end
    end
    assign dout      = (sp>0) ? mem[sp-1] : 0;
    assign full      = (sp == DEPTH);
    assign empty     = (sp == 0);
    assign overflow  = ov;
    assign underflow = un;
endmodule
