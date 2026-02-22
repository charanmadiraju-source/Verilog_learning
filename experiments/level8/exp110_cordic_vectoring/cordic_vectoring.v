// Experiment 110: CORDIC (Vectoring Mode, arctan)
// Rotates vector toward x-axis; z accumulates the angle.
// Inputs : x_in[15:0], y_in[15:0]
// Output : angle[15:0] (arctan(y_in/x_in))
module cordic_vectoring (
    input  signed [15:0] x_in, y_in,
    output signed [15:0] angle
);
    parameter N = 8;
    integer atan_table [0:7];
    initial begin
        atan_table[0]=16384; atan_table[1]=9672;  atan_table[2]=5110; atan_table[3]=2594;
        atan_table[4]=1302;  atan_table[5]=651;   atan_table[6]=326;  atan_table[7]=163;
    end
    reg signed [15:0] x[0:N], y[0:N], z[0:N];
    integer i;
    always @(*) begin
        x[0]=x_in; y[0]=y_in; z[0]=0;
        for (i=0; i<N; i=i+1) begin
            if (y[i] >= 0) begin
                x[i+1] = x[i] + (y[i] >>> i);
                y[i+1] = y[i] - (x[i] >>> i);
                z[i+1] = z[i] + atan_table[i];
            end else begin
                x[i+1] = x[i] - (y[i] >>> i);
                y[i+1] = y[i] + (x[i] >>> i);
                z[i+1] = z[i] - atan_table[i];
            end
        end
    end
    assign angle = z[N];
endmodule
