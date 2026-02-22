// Experiment 158: System Timer (with compare, overflow interrupt)
// 32-bit free-running counter with compare register and interrupt outputs.
module sys_timer(
    input clk,rst,
    input we,input[1:0]reg_addr,input[31:0]wr_data,
    output reg[31:0]rd_data,
    output reg irq_overflow,irq_compare
);
    reg[31:0]cnt,compare_r;reg ovf_en,cmp_en;
    always@(posedge clk or posedge rst)begin
        if(rst)begin cnt<=0;compare_r<=32'hFFFFFFFF;ovf_en<=0;cmp_en<=0;irq_overflow<=0;irq_compare<=0;end
        else begin
            irq_overflow<=0;irq_compare<=0;
            if(we)case(reg_addr)
                0:begin ovf_en<=wr_data[0];cmp_en<=wr_data[1];end
                1:compare_r<=wr_data;
                default:;
            endcase
            case(reg_addr) 0:rd_data<={30'b0,cmp_en,ovf_en}; 1:rd_data<=compare_r; 2:rd_data<=cnt; default:rd_data<=0; endcase
            if(cnt==32'hFFFFFFFF)begin if(ovf_en)irq_overflow<=1;cnt<=0;end
            else cnt<=cnt+1;
            if(cnt==compare_r&&cmp_en)irq_compare<=1;
        end
    end
endmodule
