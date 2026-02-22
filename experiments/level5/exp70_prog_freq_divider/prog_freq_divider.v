// Experiment 70: Programmable Frequency Divider
// Divides input clock by selectable divisor (1..15).
// Modulo counter toggles output every divisor/2 cycles.
// Inputs : clk, rst, divisor[3:0]
// Output : clk_out
module prog_freq_divider (
    input       clk, rst,
    input [3:0] divisor,
    output reg  clk_out
);
    reg [3:0] count;
    wire [3:0] half = divisor >> 1;
    always @(posedge clk or posedge rst) begin
        if (rst || divisor==0) begin count<=0; clk_out<=0; end
        else begin
            if (count >= divisor - 1) begin count<=0; clk_out<=~clk_out; end
            else if (count == half - 1) begin count<=count+1; clk_out<=~clk_out; end
            else count<=count+1;
        end
    end
endmodule
