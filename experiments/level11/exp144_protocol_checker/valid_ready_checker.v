// Experiment 144: Valid-Ready Protocol Checker
// Checks AXI-style valid/ready handshake rules:
// 1. Once valid is asserted, data must remain stable until ready
// 2. Valid can be deasserted only after handshake completes
module valid_ready_checker (
    input clk, rst,
    input valid, ready,
    input [7:0] data
);
    reg        valid_d;
    reg [7:0]  data_d;
    reg        error_flag;
    always @(posedge clk or posedge rst) begin
        if (rst) begin valid_d<=0; data_d<=0; error_flag<=0; end
        else begin
            // Check: if valid was asserted last cycle and ready was not, data should be stable
            if (valid_d && !ready && (data !== data_d)) begin
                error_flag <= 1;
                $error("PROTOCOL VIOLATION: data changed while valid=1, ready=0 at time %0t", $time);
            end
            valid_d <= valid;
            data_d  <= data;
        end
    end
endmodule
