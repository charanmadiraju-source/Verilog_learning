// Experiment 78: Vending Machine (Complex: nickel=5c, dime=10c, quarter=25c; price=25c)
// Inputs : clk, rst, nickel, dime, quarter
// Outputs: dispense, change[4:0] (change amount in cents)
module vending_complex (
    input  clk, rst, nickel, dime, quarter,
    output reg dispense,
    output reg [4:0] change
);
    reg [5:0] total;
    always @(posedge clk or posedge rst) begin
        if (rst) begin total<=0; dispense<=0; change<=0; end
        else begin
            dispense<=0; change<=0;
            if (total >= 6'd25) begin
                dispense <= 1;
                change   <= total[4:0] - 5'd25;
                total    <= 0;
            end else if (quarter) total <= total + 6'd25;
            else if (dime)        total <= total + 6'd10;
            else if (nickel)      total <= total + 6'd5;
        end
    end
endmodule
