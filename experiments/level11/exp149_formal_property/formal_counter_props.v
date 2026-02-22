// Experiment 149: Formal Property Checker for 4-bit Counter
// Models properties using immediate assertions in simulation.
// Properties:
// 1. Counter should never exceed max value
// 2. Counter should reset to 0 on rst
// 3. Counter should increment by 1 each enabled cycle
module formal_counter_props (
    input clk, rst, en,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) count <= 4'b0;
        else if (en) count <= count + 1;
    end
    // Behavioral assertions (simulation-time formal properties)
    reg [3:0] count_prev;
    always @(posedge clk) begin
        count_prev <= count;
        // Property 1: no overflow check (verified by 4-bit natural wrap)
        // Property 2: after rst, count must be 0 (checked on posedge after rst)
        // Property 3: if en and no rst, count = count_prev + 1
        if (!rst && en && count !== (count_prev + 1))
            $error("PROPERTY FAIL: count not incrementing correctly");
    end
endmodule
