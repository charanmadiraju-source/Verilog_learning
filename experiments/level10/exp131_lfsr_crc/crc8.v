// Experiment 131: CRC-8 (LFSR-based, poly=0x07, x^8+x^2+x+1)
// Inputs : clk, rst, data_in, data_valid
// Output : crc[7:0]
module crc8 (
    input        clk, rst, data_in, data_valid,
    output [7:0] crc
);
    reg [7:0] lfsr;
    wire feedback = lfsr[7] ^ data_in;
    always @(posedge clk or posedge rst) begin
        if (rst) lfsr <= 8'hFF;
        else if (data_valid) begin
            lfsr[7] <= lfsr[6];
            lfsr[6] <= lfsr[5];
            lfsr[5] <= lfsr[4];
            lfsr[4] <= lfsr[3];
            lfsr[3] <= lfsr[2];
            lfsr[2] <= lfsr[1] ^ feedback;
            lfsr[1] <= lfsr[0] ^ feedback;
            lfsr[0] <= feedback;
        end
    end
    assign crc = lfsr;
endmodule
