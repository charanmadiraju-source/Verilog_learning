// 8-to-3 Priority Encoder
// Highest numbered active input wins; valid=1 when any input is active
module priority_encoder_8to3 (
    input  [7:0] in,
    output reg [2:0] out,
    output reg valid
);
    always @(*) begin
        casez (in)
            8'b1???????: begin out = 3'd7; valid = 1; end
            8'b01??????: begin out = 3'd6; valid = 1; end
            8'b001?????: begin out = 3'd5; valid = 1; end
            8'b0001????: begin out = 3'd4; valid = 1; end
            8'b00001???: begin out = 3'd3; valid = 1; end
            8'b000001??: begin out = 3'd2; valid = 1; end
            8'b0000001?: begin out = 3'd1; valid = 1; end
            8'b00000001: begin out = 3'd0; valid = 1; end
            default:     begin out = 3'd0; valid = 0; end
        endcase
    end
endmodule
