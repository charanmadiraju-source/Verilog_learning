// Experiment 68: Programmable Delay Counter
// Counts from 0 to timeout_val then pulses done=1 for one cycle.
// Inputs : clk, rst, start, timeout_val[7:0]
// Output : done
module delay_counter #(parameter WIDTH=8) (
    input              clk, rst, start,
    input  [WIDTH-1:0] timeout_val,
    output             done
);
    reg [WIDTH-1:0] count;
    reg             running;
    always @(posedge clk or posedge rst) begin
        if (rst) begin count <= 0; running <= 0; end
        else if (start && !running) begin count <= 0; running <= 1; end
        else if (running) begin
            if (count == timeout_val - 1) begin count <= 0; running <= 0; end
            else count <= count + 1;
        end
    end
    assign done = running && (count == timeout_val - 1);
endmodule
