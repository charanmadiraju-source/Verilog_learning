// Experiment 62: BCD Counter (0-9, decade counter)
// Resets to 0 after reaching 9. carry pulses high at the reset.
// Inputs : clk, rst
// Outputs: count[3:0], carry
module bcd_counter (
    input  clk, rst,
    output reg [3:0] count,
    output carry
);
    always @(posedge clk or posedge rst) begin
        if (rst || count == 4'd9) count <= 4'b0;
        else                      count <= count + 1'b1;
    end
    assign carry = (count == 4'd9);
endmodule
