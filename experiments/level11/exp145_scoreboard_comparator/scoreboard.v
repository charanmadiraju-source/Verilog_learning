// Experiment 145: Scoreboard / Result Comparator
// Compares DUT output against golden model output.
// For an 8-bit multiplier: golden = a*b; checks every output.
module scoreboard (
    input        clk, rst, valid,
    input  [7:0] a, b,
    input  [15:0] dut_out,
    output reg   pass, fail,
    output reg [31:0] pass_cnt, fail_cnt
);
    wire [15:0] golden = a * b;
    always @(posedge clk or posedge rst) begin
        if (rst) begin pass<=0;fail<=0;pass_cnt<=0;fail_cnt<=0; end
        else if (valid) begin
            if (dut_out === golden) begin pass<=1;fail<=0;pass_cnt<=pass_cnt+1; end
            else begin pass<=0;fail<=1;fail_cnt<=fail_cnt+1;
                $display("SCOREBOARD FAIL: %0d*%0d: got=%0d expected=%0d",a,b,dut_out,golden);
            end
        end else begin pass<=0;fail<=0; end
    end
endmodule
