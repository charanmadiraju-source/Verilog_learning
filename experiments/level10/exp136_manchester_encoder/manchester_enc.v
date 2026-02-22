// Experiment 136: Manchester Encoder
// Encodes each bit as a mid-bit transition:
// '0' = low-to-high, '1' = high-to-low (IEEE 802.3 convention)
// Clock-synchronized: outputs two phases per data bit.
// Inputs : clk, rst, data_in, data_valid
// Output : manchester_out
module manchester_enc (
    input  clk, rst, data_in, data_valid,
    output reg manchester_out
);
    reg phase; // 0=first half, 1=second half
    reg data_latch;
    always @(posedge clk or posedge rst) begin
        if (rst) begin phase<=0; manchester_out<=0; data_latch<=0; end
        else if (data_valid) begin
            if (!phase) begin
                data_latch      <= data_in;
                manchester_out  <= ~data_in; // first half: complement
                phase           <= 1;
            end else begin
                manchester_out  <= data_latch; // second half: original
                phase           <= 0;
            end
        end
    end
endmodule
