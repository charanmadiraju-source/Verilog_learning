// Experiment 147: Setup and Hold Time Constraint Checker
// Behavioral model that monitors data changes relative to clock edges.
// Reports violations when data changes within setup/hold window.
// setup_time: minimum time data must be stable before clock edge (in ns)
// hold_time:  minimum time data must remain stable after clock edge (in ns)
`timescale 1ns/1ps
module setup_hold_checker #(
    parameter real SETUP_TIME = 2.0,
    parameter real HOLD_TIME  = 1.0
)(
    input clk, data,
    output reg setup_violation,
    output reg hold_violation
);
    real last_data_change;
    real last_clk_edge;
    initial begin last_data_change=0; last_clk_edge=0; end
    always @(data) last_data_change = $realtime;
    always @(posedge clk) begin
        last_clk_edge = $realtime;
        setup_violation <= 0; hold_violation <= 0;
        // Check setup: data must not have changed within SETUP_TIME before this edge
        if (($realtime - last_data_change) < SETUP_TIME) begin
            setup_violation <= 1;
            $display("SETUP VIOLATION at time %0t: data changed only %0t before clk",
                      $realtime, $realtime-last_data_change);
        end
    end
    always @(data) begin
        // Check hold: data must not change within HOLD_TIME after last clock edge
        if (($realtime - last_clk_edge) < HOLD_TIME && last_clk_edge > 0) begin
            hold_violation <= 1;
            $display("HOLD VIOLATION at time %0t: data changed only %0t after clk",
                      $realtime, $realtime-last_clk_edge);
        end
    end
endmodule
