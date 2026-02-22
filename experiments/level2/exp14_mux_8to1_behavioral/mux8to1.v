// Experiment 14: 8-to-1 Multiplexer (Behavioral)
// Uses a case statement inside always @(*) to select one of 8 inputs.
// Inputs : d[7:0], sel[2:0]
// Output : y
module mux8to1 (
    input  [7:0] d,
    input  [2:0] sel,
    output reg   y
);
    always @(*) begin
        case (sel)
            3'd0: y = d[0];
            3'd1: y = d[1];
            3'd2: y = d[2];
            3'd3: y = d[3];
            3'd4: y = d[4];
            3'd5: y = d[5];
            3'd6: y = d[6];
            3'd7: y = d[7];
            default: y = 1'b0;
        endcase
    end
endmodule
