// 8-Bit Booth's Algorithm Multiplier (signed)
// Multiplies two 8-bit signed numbers using radix-2 Booth algorithm
module booth_multiplier_8bit (
    input  clk,
    input  rst_n,
    input  start,
    input  signed [7:0] multiplicand,
    input  signed [7:0] multiplier,
    output reg signed [15:0] product,
    output reg done
);
    reg signed [15:0] A;     // accumulator
    reg signed [8:0]  Q;     // {Q[7:0], q_minus1}
    reg [7:0]         M;     // multiplicand copy
    reg [3:0]         count; // iteration counter (1..8)

    // Combinational: compute updated accumulator before shift
    reg signed [15:0] A_next;
    always @(*) begin
        case (Q[1:0])
            2'b01:   A_next = A + {{8{M[7]}}, M};
            2'b10:   A_next = A - {{8{M[7]}}, M};
            default: A_next = A;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A <= 0; Q <= 0; M <= 0; count <= 0; done <= 0; product <= 0;
        end else if (start && count == 0 && !done) begin
            // Initialize
            A     <= 16'sd0;
            Q     <= {multiplier, 1'b0};
            M     <= multiplicand;
            count <= 1;
            done  <= 0;
        end else if (count >= 1 && count <= 8) begin
            // Booth step: add/subtract then arithmetic right shift {A, Q}
            {A, Q} <= {A_next[15], A_next, Q[8:1]};
            count  <= count + 1'b1;
        end else if (count == 9) begin
            product <= {A[7:0], Q[8:1]};  // upper 8 bits in A, lower 8 bits in Q
            done    <= 1;
            count   <= 0;
        end else if (!start) begin
            done <= 0;
        end
    end
endmodule
