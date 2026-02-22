// Experiment 109: CORDIC (Rotation Mode, 8 iterations)
// Rotates vector (x,y) by angle z using iterative shifts.
// Uses fixed-point Q1.15 representation.
// Inputs : x_in[15:0], y_in[15:0], z_in[15:0] (angle in Q1.15 radians)
// Outputs: x_out[15:0], y_out[15:0]
module cordic_rotation (
    input  signed [15:0] x_in, y_in, z_in,
    output signed [15:0] x_out, y_out
);
    // CORDIC angles in Q1.15: atan(2^-i) * 2^15 / (pi/2)
    parameter N = 8;
    integer angles [0:7];
    initial begin
        angles[0] = 16384; // atan(1)    = 45 deg  -> 16384 (Q1.15 fraction of pi/2)
        angles[1] = 9672;  // atan(0.5)  = 26.57
        angles[2] = 5110;  // atan(0.25) = 14.04
        angles[3] = 2594;
        angles[4] = 1302;
        angles[5] = 651;
        angles[6] = 326;
        angles[7] = 163;
    end

    reg signed [15:0] x[0:N], y[0:N], z[0:N];
    integer i;
    always @(*) begin
        x[0] = x_in; y[0] = y_in; z[0] = z_in;
        for (i = 0; i < N; i = i+1) begin
            if (z[i] >= 0) begin
                x[i+1] = x[i] - (y[i] >>> i);
                y[i+1] = y[i] + (x[i] >>> i);
                z[i+1] = z[i] - angles[i];
            end else begin
                x[i+1] = x[i] + (y[i] >>> i);
                y[i+1] = y[i] - (x[i] >>> i);
                z[i+1] = z[i] + angles[i];
            end
        end
    end
    assign x_out = x[N];
    assign y_out = y[N];
endmodule
