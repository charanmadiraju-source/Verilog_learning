// BCD to 7-Segment Display Decoder
// Active-high segments: seg[6]=g, seg[5]=f, seg[4]=e, seg[3]=d,
//                       seg[2]=c, seg[1]=b, seg[0]=a
//   aaa
//  f   b
//  f   b
//   ggg
//  e   c
//  e   c
//   ddd
module bcd_to_7seg (
    input  [3:0] bcd,
    output reg [6:0] seg  // {g,f,e,d,c,b,a}
);
    always @(*) begin
        case (bcd)
            4'd0: seg = 7'b0111111; // 0: a,b,c,d,e,f on
            4'd1: seg = 7'b0000110; // 1: b,c on
            4'd2: seg = 7'b1011011; // 2: a,b,d,e,g on
            4'd3: seg = 7'b1001111; // 3: a,b,c,d,g on
            4'd4: seg = 7'b1100110; // 4: b,c,f,g on
            4'd5: seg = 7'b1101101; // 5: a,c,d,f,g on
            4'd6: seg = 7'b1111101; // 6: a,c,d,e,f,g on
            4'd7: seg = 7'b0000111; // 7: a,b,c on
            4'd8: seg = 7'b1111111; // 8: all on
            4'd9: seg = 7'b1101111; // 9: a,b,c,d,f,g on
            default: seg = 7'b0000000;
        endcase
    end
endmodule
