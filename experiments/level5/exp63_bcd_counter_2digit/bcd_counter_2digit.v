// Experiment 63: 2-digit BCD Counter (00-99)
// Cascaded decades: ones drives tens on carry.
// Inputs : clk, rst
// Outputs: tens[3:0], ones[3:0]
module bcd_counter_1digit (
    input  clk, rst,
    output reg [3:0] count,
    output carry
);
    always @(posedge clk or posedge rst) begin
        if (rst || count==4'd9) count <= 4'b0;
        else                    count <= count + 1'b1;
    end
    assign carry = (count==4'd9);
endmodule

module bcd_counter_2digit (
    input  clk, rst,
    output [3:0] tens, ones
);
    wire carry_ones;
    bcd_counter_1digit ones_cnt(.clk(clk),.rst(rst),.count(ones),.carry(carry_ones));
    // Tens increments on carry from ones
    reg [3:0] tens_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) tens_reg <= 4'b0;
        else if (carry_ones) begin
            if (tens_reg==4'd9) tens_reg <= 4'b0;
            else                tens_reg <= tens_reg + 1'b1;
        end
    end
    assign tens = tens_reg;
endmodule
