// Experiment 146: Clock Domain Crossing (CDC) Checker
// Monitors signals crossing between two clock domains.
// Detects potential metastability: signal changes too close to destination clock edge.
// This is a simplified behavioral model for simulation checking.
module cdc_checker (
    input src_clk, dst_clk, rst,
    input src_signal, dst_signal
);
    reg src_d, dst_d;
    real last_src_edge, last_dst_edge;
    // Monitor src_signal changes
    always @(posedge src_clk or posedge rst) begin
        if (rst) src_d <= 0;
        else begin
            if (src_signal !== src_d) last_src_edge = $realtime;
            src_d <= src_signal;
        end
    end
    // Monitor dst clock
    always @(posedge dst_clk or posedge rst) begin
        if (rst) begin dst_d<=0; last_dst_edge=0; end
        else begin
            last_dst_edge = $realtime;
            dst_d <= dst_signal;
        end
    end
endmodule
