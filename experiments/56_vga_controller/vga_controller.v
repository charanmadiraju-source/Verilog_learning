// VGA Controller – 640×480 @ 60 Hz (25 MHz pixel clock assumed)
// Horizontal: 640 active + 16 front porch + 96 sync + 48 back porch = 800
// Vertical:   480 active + 10 front porch + 2  sync + 33 back porch = 525
module vga_controller (
    input        pclk,     // 25 MHz pixel clock
    input        rst_n,
    output reg   hsync,
    output reg   vsync,
    output       h_active, // high when in visible horizontal region
    output       v_active, // high when in visible vertical region
    output [9:0] h_count,  // current pixel column (0-799)
    output [9:0] v_count   // current pixel row    (0-524)
);
    // Horizontal timing (in pixels)
    localparam H_ACTIVE = 640, H_FP = 16, H_SYNC = 96, H_BP = 48;
    localparam H_TOTAL  = H_ACTIVE + H_FP + H_SYNC + H_BP; // 800

    // Vertical timing (in lines)
    localparam V_ACTIVE = 480, V_FP = 10, V_SYNC = 2, V_BP = 33;
    localparam V_TOTAL  = V_ACTIVE + V_FP + V_SYNC + V_BP; // 525

    reg [9:0] hcnt, vcnt;
    assign h_count  = hcnt;
    assign v_count  = vcnt;
    assign h_active = (hcnt < H_ACTIVE);
    assign v_active = (vcnt < V_ACTIVE);

    always @(posedge pclk or negedge rst_n) begin
        if (!rst_n) begin
            hcnt <= 0; vcnt <= 0; hsync <= 1; vsync <= 1;
        end else begin
            if (hcnt == H_TOTAL - 1) begin
                hcnt <= 0;
                vcnt <= (vcnt == V_TOTAL - 1) ? 10'd0 : vcnt + 1'b1;
            end else begin
                hcnt <= hcnt + 1'b1;
            end
            // HSYNC pulse (active-low)
            hsync <= ~((hcnt >= H_ACTIVE + H_FP) && (hcnt < H_ACTIVE + H_FP + H_SYNC));
            // VSYNC pulse (active-low)
            vsync <= ~((vcnt >= V_ACTIVE + V_FP) && (vcnt < V_ACTIVE + V_FP + V_SYNC));
        end
    end
endmodule
