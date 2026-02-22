// Experiment 82: Password Lock (4-digit sequence: 1,0,1,1)
// Shift register stores last 4 inputs; compare to fixed password.
// Inputs : clk, rst, digit_in
// Output : unlocked
module password_lock (
    input  clk, rst, digit_in,
    output unlocked
);
    localparam [3:0] PASSWORD = 4'b1011;
    reg [3:0] history;
    always @(posedge clk or posedge rst) begin
        if (rst) history <= 4'b0;
        else     history <= {history[2:0], digit_in};
    end
    assign unlocked = (history == PASSWORD);
endmodule
