// Experiment 98: Sequential Multiplier (Shift-and-Add)
// Computes a*b using sequential shift-and-add algorithm.
// Inputs : clk, rst, start, a[7:0], b[7:0]
// Outputs: product[15:0], done
module seq_multiplier (
    input        clk, rst, start,
    input  [7:0] a, b,
    output reg [15:0] product,
    output reg        done
);
    reg [7:0]  multiplicand;
    reg [7:0]  multiplier;
    reg [3:0]  count;
    reg        busy;
    always @(posedge clk or posedge rst) begin
        if (rst) begin product<=0; done<=0; busy<=0; end
        else if (start && !busy) begin
            product<=0; multiplicand<=a; multiplier<=b; count<=0; busy<=1; done<=0;
        end else if (busy) begin
            if (multiplier[0]) product <= product + (multiplicand << count);
            multiplier <= multiplier >> 1;
            count      <= count + 1;
            if (count == 7) begin done<=1; busy<=0; end
        end else done<=0;
    end
endmodule
