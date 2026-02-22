// Experiment 77: Vending Machine (Simple: 15 cents, nickel=5c, dime=10c)
// Accumulator state; dispenses when accumulated >= 15, gives change.
// Inputs : clk, rst, nickel, dime
// Outputs: dispense, change (change=1 means 5c change returned)
module vending_machine (
    input  clk, rst, nickel, dime,
    output reg dispense,
    output reg change
);
    reg [4:0] total;
    always @(posedge clk or posedge rst) begin
        if (rst) begin total<=0; dispense<=0; change<=0; end
        else begin
            dispense <= 0; change <= 0;
            if (total >= 5'd15) begin
                dispense <= 1;
                if (total > 5'd15) change <= 1;
                total <= 0;
            end else if (nickel) total <= total + 5'd5;
            else if (dime)       total <= total + 5'd10;
        end
    end
endmodule
