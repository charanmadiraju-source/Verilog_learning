// Clock Divider
// Generates clk_out with frequency = clk_in / (2 * DIV_FACTOR)
// Also provides a pulse output at the divided rate (single-cycle high)
module clock_divider #(
    parameter DIV_FACTOR = 4
)(
    input  clk,
    input  rst_n,
    output reg clk_div,   // divided clock (50% duty cycle)
    output reg pulse      // single-cycle pulse at divided rate
);
    reg [$clog2(DIV_FACTOR)-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0; clk_div <= 0; pulse <= 0;
        end else begin
            pulse <= 0;
            if (cnt == DIV_FACTOR - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div;
                pulse   <= ~clk_div;  // pulse on rising edge of clk_div
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end
endmodule
