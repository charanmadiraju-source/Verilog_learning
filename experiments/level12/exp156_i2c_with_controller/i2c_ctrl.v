// Experiment 156: I2C with Register Controller
// Wraps I2C master with a register map for SoC integration.
// Regs: 0=control(start,stop), 1=addr, 2=wdata, 3=status
module i2c_ctrl(
    input clk,rst,
    input we, input [1:0] reg_addr, input [7:0] wr_data,
    output reg [7:0] rd_data,
    output reg sda,scl,done
);
    reg [7:0] ctrl,addr_r,wdata_r,status;
    reg [4:0] cnt; reg busy;
    always@(posedge clk or posedge rst)begin
        if(rst)begin ctrl<=0;addr_r<=0;wdata_r<=0;status<=0;done<=0;busy<=0;sda<=1;scl<=1;cnt<=0;end
        else begin
            done<=0;
            if(we)case(reg_addr)
                0:ctrl<=wr_data; 1:addr_r<=wr_data; 2:wdata_r<=wr_data; default:;
            endcase
            case(reg_addr) 0:rd_data<=ctrl; 1:rd_data<=addr_r; 2:rd_data<=wdata_r; 3:rd_data<=status; endcase
            if(ctrl[0]&&!busy)begin busy<=1;cnt<=0;sda<=0;end
            else if(busy)begin cnt<=cnt+1;scl<=~scl;
                if(cnt==30)begin busy<=0;done<=1;status<=8'h01;sda<=1;scl<=1;end
            end
        end
    end
endmodule
