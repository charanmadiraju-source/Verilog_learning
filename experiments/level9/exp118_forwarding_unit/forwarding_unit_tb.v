`timescale 1ns/1ps
module forwarding_unit_tb;
    reg [4:0] ex_mem_rd,mem_wb_rd,id_ex_rs,id_ex_rt;
    reg ex_mem_regwrite,mem_wb_regwrite;
    wire [1:0] forward_a,forward_b;
    forwarding_unit uut(.ex_mem_rd(ex_mem_rd),.mem_wb_rd(mem_wb_rd),
        .id_ex_rs(id_ex_rs),.id_ex_rt(id_ex_rt),
        .ex_mem_regwrite(ex_mem_regwrite),.mem_wb_regwrite(mem_wb_regwrite),
        .forward_a(forward_a),.forward_b(forward_b));
    integer errors=0;
    initial begin
        $dumpfile("forwarding_unit.vcd"); $dumpvars(0,forwarding_unit_tb);
        // EX/MEM forward for RS
        ex_mem_regwrite=1;ex_mem_rd=5'd3;mem_wb_regwrite=0;mem_wb_rd=5'd0;
        id_ex_rs=5'd3;id_ex_rt=5'd4; #5;
        if(forward_a!==2'b10)begin $display("FAIL EX/MEM fwd_a=%b",forward_a);errors=errors+1;end
        if(forward_b!==2'b00)begin $display("FAIL no fwd_b");errors=errors+1;end
        // MEM/WB forward
        ex_mem_regwrite=0;mem_wb_regwrite=1;mem_wb_rd=5'd4;
        id_ex_rs=5'd5;id_ex_rt=5'd4; #5;
        if(forward_b!==2'b01)begin $display("FAIL MEM/WB fwd_b=%b",forward_b);errors=errors+1;end
        // No forward
        ex_mem_regwrite=0;mem_wb_regwrite=0;
        id_ex_rs=5'd1;id_ex_rt=5'd2; #5;
        if(forward_a!==2'b00||forward_b!==2'b00)begin $display("FAIL no forward");errors=errors+1;end
        if(errors==0) $display("PASS: Forwarding Unit test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
