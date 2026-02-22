// Experiment 81: Washing Machine Controller (Fill, Wash, Rinse, Spin)
// Each state lasts a fixed number of cycles. done pulses at end.
// Inputs : clk, rst, start
// Outputs: fill, wash, rinse, spin, done
module washing_machine #(
    parameter FILL_T=3, WASH_T=4, RINSE_T=3, SPIN_T=2
) (
    input  clk, rst, start,
    output fill, wash, rinse, spin, done
);
    localparam IDLE=3'd0, FILL=3'd1, WASH=3'd2, RINSE=3'd3, SPIN=3'd4, DONE=3'd5;
    reg [2:0] state;
    reg [3:0] timer;
    always @(posedge clk or posedge rst) begin
        if (rst) begin state<=IDLE; timer<=0; end
        else case (state)
            IDLE:  if(start) begin state<=FILL;  timer<=0; end
            FILL:  begin timer<=timer+1; if(timer>=FILL_T-1)  begin state<=WASH;  timer<=0; end end
            WASH:  begin timer<=timer+1; if(timer>=WASH_T-1)  begin state<=RINSE; timer<=0; end end
            RINSE: begin timer<=timer+1; if(timer>=RINSE_T-1) begin state<=SPIN;  timer<=0; end end
            SPIN:  begin timer<=timer+1; if(timer>=SPIN_T-1)  begin state<=DONE;  timer<=0; end end
            DONE:  state<=IDLE;
            default: state<=IDLE;
        endcase
    end
    assign fill  = (state==FILL);
    assign wash  = (state==WASH);
    assign rinse = (state==RINSE);
    assign spin  = (state==SPIN);
    assign done  = (state==DONE);
endmodule
