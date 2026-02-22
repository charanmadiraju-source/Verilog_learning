// Experiment 119: 2-bit Branch Predictor (4-entry BHT)
// 2-bit saturating counter: 00=StrongNotTaken, 01=WeakNotTaken,
// 10=WeakTaken, 11=StrongTaken.
// Inputs : clk, rst, pc_index[1:0], actual_taken, update
// Outputs: predict_taken
module branch_predictor (
    input        clk, rst,
    input  [1:0] pc_index,
    input        actual_taken, update,
    output       predict_taken
);
    reg [1:0] bht [0:3];
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin for(i=0;i<4;i=i+1) bht[i]<=2'b01; end // WeakNotTaken
        else if (update) begin
            if (actual_taken) bht[pc_index] <= (bht[pc_index]==2'b11) ? 2'b11 : bht[pc_index]+1;
            else              bht[pc_index] <= (bht[pc_index]==2'b00) ? 2'b00 : bht[pc_index]-1;
        end
    end
    assign predict_taken = bht[pc_index][1];
endmodule
