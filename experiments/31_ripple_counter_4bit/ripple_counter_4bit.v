// 4-Bit Ripple (Asynchronous) Counter
// Each flip-flop is clocked by the output of the previous one
module ripple_counter_4bit (
    input  clk,
    input  rst_n,
    output [3:0] q
);
    // Each stage toggles on the falling edge of the previous stage's output
    wire [3:0] q_internal;

    // Bit 0 clocked by external clk
    dff_t ff0 (.clk(clk),   .rst_n(rst_n), .q(q_internal[0]));
    dff_t ff1 (.clk(q_internal[0]), .rst_n(rst_n), .q(q_internal[1]));
    dff_t ff2 (.clk(q_internal[1]), .rst_n(rst_n), .q(q_internal[2]));
    dff_t ff3 (.clk(q_internal[2]), .rst_n(rst_n), .q(q_internal[3]));

    assign q = q_internal;
endmodule

// Helper: T flip-flop that always toggles (T=1 permanently)
module dff_t (
    input  clk,
    input  rst_n,
    output reg q
);
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) q <= 1'b0;
        else        q <= ~q;
    end
endmodule
