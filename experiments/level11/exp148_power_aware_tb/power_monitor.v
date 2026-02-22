// Experiment 148: Power-Aware Testbench with Activity Monitor
// Tracks signal toggle counts as a proxy for dynamic power.
// Higher toggle rate = higher dynamic power consumption.
module power_monitor (
    input clk, rst,
    input [7:0] bus_signals,
    output reg [31:0] toggle_count,
    output reg [7:0]  prev_state
);
    wire [7:0] diff = bus_signals ^ prev_state;
    // Count number of set bits in diff (popcount)
    function [3:0] popcount8;
        input [7:0] x;
        begin
            popcount8 = x[0]+x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7];
        end
    endfunction
    always @(posedge clk or posedge rst) begin
        if (rst) begin toggle_count<=0; prev_state<=0; end
        else begin
            toggle_count <= toggle_count + popcount8(diff);
            prev_state   <= bus_signals;
        end
    end
endmodule
