// Experiment 159: Power Management Unit
// Controls clock gating and power domains for 4 sub-modules.
// Clock enable register: writing 1 enables clock to that domain.
// Wakeup: external request auto-enables the domain.
module power_mgmt(
    input clk,rst,
    input we,input[1:0]reg_addr,input[7:0]wr_data,
    input[3:0]wakeup_req,
    output reg[7:0]rd_data,
    output reg[3:0]clk_en,
    output reg[3:0]pwr_gate
);
    reg[3:0]clk_en_r,pwr_gate_r;
    always@(posedge clk or posedge rst)begin
        if(rst)begin clk_en_r<=4'b0001;pwr_gate_r<=4'b1110;end // domain0 on by default
        else begin
            if(we && reg_addr==0)
                clk_en_r <= wr_data[3:0] | wakeup_req;
            else
                clk_en_r <= clk_en_r | wakeup_req;
            if(we && reg_addr==1)
                pwr_gate_r <= wr_data[3:0];
            case(reg_addr) 0:rd_data<={4'b0,clk_en_r}; 1:rd_data<={4'b0,pwr_gate_r}; default:rd_data<=0; endcase
        end
    end
    always@(*)begin clk_en=clk_en_r;pwr_gate=pwr_gate_r;end
endmodule
