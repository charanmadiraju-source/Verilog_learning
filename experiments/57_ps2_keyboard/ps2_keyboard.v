// PS/2 Keyboard Interface – Receiver (scan-code decoder)
// PS/2 uses 11-bit frames: 1 start(0), 8 data, 1 parity(odd), 1 stop(1)
module ps2_keyboard (
    input        clk,
    input        rst_n,
    input        ps2_clk,    // PS/2 clock (falling-edge triggered)
    input        ps2_data,
    output reg [7:0] scan_code,
    output reg       valid    // pulses when a new scan code is ready
);
    // Synchronize ps2_clk into system clock domain
    reg [2:0] ps2_clk_sync;
    wire ps2_clk_fall = ps2_clk_sync[2] && !ps2_clk_sync[1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) ps2_clk_sync <= 3'b111;
        else        ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
    end

    reg [10:0] shift_reg;
    reg [3:0]  bit_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_cnt <= 0; valid <= 0; scan_code <= 0;
        end else begin
            valid <= 0;
            if (ps2_clk_fall) begin
                shift_reg <= {ps2_data, shift_reg[10:1]};  // LSB first
                bit_cnt   <= bit_cnt + 1'b1;
                if (bit_cnt == 10) begin
                    // Frame complete: [10]=stop, [9]=parity, [8:1]=data, [0]=start
                    if (shift_reg[0] == 0 && ps2_data == 1) begin // start=0, stop=1
                        scan_code <= shift_reg[8:1];
                        valid     <= 1;
                    end
                    bit_cnt <= 0;
                end
            end
        end
    end
endmodule
