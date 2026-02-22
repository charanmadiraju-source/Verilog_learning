// Experiment 40: Barrel Shifter (4-bit, Left/Right)
// Shifts by 0-3 positions in one clock using case statement.
// Inputs : in[3:0], shift[1:0], dir (0=left, 1=right)
// Output : out[3:0]
module barrel_shifter_4bit (
    input  [3:0] in,
    input  [1:0] shift,
    input        dir,
    output reg [3:0] out
);
    always @(*) begin
        if (dir == 1'b0) begin
            case (shift)
                2'd0: out = in;
                2'd1: out = in << 1;
                2'd2: out = in << 2;
                2'd3: out = in << 3;
                default: out = in;
            endcase
        end else begin
            case (shift)
                2'd0: out = in;
                2'd1: out = in >> 1;
                2'd2: out = in >> 2;
                2'd3: out = in >> 3;
                default: out = in;
            endcase
        end
    end
endmodule
