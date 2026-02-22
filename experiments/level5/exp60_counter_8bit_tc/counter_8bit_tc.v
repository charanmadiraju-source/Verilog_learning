// Experiment 60: 8-bit Counter with Terminal Count
// tc goes high for one cycle when count reaches 255.
// Inputs : clk, rst
// Outputs: count[7:0], tc
module counter_8bit_tc (
    input  clk, rst,
    output reg [7:0] count,
    output tc
);
    always @(posedge clk or posedge rst) begin
        if (rst) count <= 8'b0;
        else     count <= count + 1'b1;
    end
    assign tc = (count == 8'hFF);
endmodule
