// Experiment 24: BCD to 7-Segment Decoder
// Converts a 4-bit BCD digit (0-9) to 7-segment display encoding.
// Segments are active-low: seg[6:0] = {g,f,e,d,c,b,a}
// Input  : bcd[3:0]
// Output : seg[6:0]
module bcd_to_7seg (
    input  [3:0] bcd,
    output reg [6:0] seg
);
    always @(*) begin
        case (bcd)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // blank
        endcase
    end
endmodule
