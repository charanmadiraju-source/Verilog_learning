// Experiment 137: NRZ-L Encoder with Bit Stuffing
// Inserts a '0' after 5 consecutive '1's (HDLC-style bit stuffing).
// Inputs : clk, rst, data_in, data_valid
// Outputs: nrz_out, stuff_inserted
module nrz_enc (
    input  clk, rst, data_in, data_valid,
    output reg nrz_out, stuff_inserted
);
    reg [2:0] ones_count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin ones_count<=0; nrz_out<=0; stuff_inserted<=0; end
        else begin
            stuff_inserted<=0;
            if (data_valid) begin
                if (ones_count == 5) begin
                    // Stuff a 0
                    nrz_out<=0; stuff_inserted<=1; ones_count<=0;
                end else begin
                    nrz_out<=data_in;
                    if (data_in) ones_count<=ones_count+1;
                    else         ones_count<=0;
                end
            end
        end
    end
endmodule
