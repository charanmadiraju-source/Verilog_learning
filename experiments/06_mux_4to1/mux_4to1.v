// 4-to-1 Multiplexer
// sel[1:0]: 00->i0, 01->i1, 10->i2, 11->i3
module mux_4to1 (
    input  i0, i1, i2, i3,
    input  [1:0] sel,
    output reg y
);
    always @(*) begin
        case (sel)
            2'b00: y = i0;
            2'b01: y = i1;
            2'b10: y = i2;
            2'b11: y = i3;
        endcase
    end
endmodule
