// 4-Bit Parallel Register with synchronous load
module register_4bit (
    input        clk,
    input        rst_n,
    input        load,
    input  [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0;
        else if (load)
            q <= d;
    end
endmodule
