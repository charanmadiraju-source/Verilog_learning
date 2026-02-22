// Experiment 36: 4-bit Divider (Restoring Algorithm)
// Iterative subtraction-based combinational division.
// Inputs : dividend[3:0], divisor[3:0]
// Outputs: quotient[3:0], remainder[3:0]
// Note: divisor=0 yields quotient=0, remainder=dividend
module divider_4bit (
    input  [3:0] dividend,
    input  [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    integer i;
    reg [7:0] acc;
    always @(*) begin
        if (divisor == 4'b0) begin
            quotient  = 4'b0;
            remainder = dividend;
        end else begin
            acc = {4'b0000, dividend};
            quotient = 4'b0;
            for (i = 3; i >= 0; i = i - 1) begin
                if (acc[7:4] >= divisor) begin
                    acc[7:4]  = acc[7:4] - divisor;
                    quotient[i] = 1'b1;
                end
            end
            remainder = acc[3:0];
            // Align: use top nibble as remainder after shifting
            quotient  = 4'b0;
            remainder = dividend;
            begin : div_block
                reg [7:0] p;
                reg [3:0] q;
                integer j;
                p = {4'b0, dividend};
                q = 4'b0;
                for (j = 3; j >= 0; j = j - 1) begin
                    p = p << 1;
                    if (p[7:4] >= divisor) begin
                        p[7:4] = p[7:4] - divisor;
                        q[j]   = 1'b1;
                    end
                end
                quotient  = q;
                remainder = p[7:4];
            end
        end
    end
endmodule
