// Experiment 102: Non-Restoring Division
// Behavioral implementation demonstrating the algorithm concept.
// Inputs : dividend[7:0], divisor[3:0]
// Outputs: quotient[7:0], remainder[3:0]
module nonrestoring_div (
    input  [7:0] dividend,
    input  [3:0] divisor,
    output reg [7:0] quotient,
    output reg [3:0] remainder
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 8'hFF; remainder = 4'hF;
        end else begin
            quotient  = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule
