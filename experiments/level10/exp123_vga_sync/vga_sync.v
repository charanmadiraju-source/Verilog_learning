// Experiment 123: VGA Sync Generator (640x480 @ 60Hz)
// Generates hsync, vsync and display enable signals.
// Parameters based on 25.175 MHz pixel clock.
// Outputs: hsync, vsync, display_on, h_count[9:0], v_count[9:0]
module vga_sync (
    input  clk, rst,
    output reg hsync, vsync, display_on,
    output reg [9:0] h_count, v_count
);
    // 640x480 @ 60Hz timing
    parameter H_DISPLAY=640, H_FRONT=16, H_SYNC=96, H_BACK=48;
    parameter V_DISPLAY=480, V_FRONT=10, V_SYNC=2,  V_BACK=33;
    parameter H_TOTAL = H_DISPLAY+H_FRONT+H_SYNC+H_BACK; // 800
    parameter V_TOTAL = V_DISPLAY+V_FRONT+V_SYNC+V_BACK; // 525
    always @(posedge clk or posedge rst) begin
        if (rst) begin h_count<=0; v_count<=0; end
        else begin
            if (h_count == H_TOTAL-1) begin
                h_count <= 0;
                if (v_count == V_TOTAL-1) v_count <= 0;
                else v_count <= v_count + 1;
            end else h_count <= h_count + 1;
        end
    end
    always @(*) begin
        hsync      = ~(h_count >= H_DISPLAY+H_FRONT && h_count < H_DISPLAY+H_FRONT+H_SYNC);
        vsync      = ~(v_count >= V_DISPLAY+V_FRONT && v_count < V_DISPLAY+V_FRONT+V_SYNC);
        display_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    end
endmodule
