// Debounce Circuit
// Filters mechanical bounce by requiring the input to be stable for
// STABLE_TIME clock cycles before updating the output
module debounce #(
    parameter STABLE_CYCLES = 1000
)(
    input  clk,
    input  rst_n,
    input  noisy,      // raw (bouncy) input
    output reg stable  // debounced output
);
    reg [$clog2(STABLE_CYCLES)-1:0] cnt;
    reg prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0; stable <= 0; prev <= 0;
        end else begin
            if (noisy != prev) begin
                cnt  <= 0;
                prev <= noisy;
            end else if (cnt < STABLE_CYCLES - 1) begin
                cnt <= cnt + 1'b1;
            end else begin
                stable <= prev;
            end
        end
    end
endmodule
