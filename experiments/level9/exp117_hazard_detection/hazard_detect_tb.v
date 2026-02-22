`timescale 1ns/1ps
module hazard_detect_tb;
    reg [4:0] ex_rd,id_rs,id_rt; reg ex_memread; wire stall;
    hazard_detect uut(.ex_rd(ex_rd),.id_rs(id_rs),.id_rt(id_rt),.ex_memread(ex_memread),.stall(stall));
    integer errors=0;
    initial begin
        $dumpfile("hazard_detect.vcd"); $dumpvars(0,hazard_detect_tb);
        // No memread: no stall
        ex_memread=0;ex_rd=5'd3;id_rs=5'd3;id_rt=5'd0;#5;
        if(stall!==0)begin $display("FAIL no memread should not stall");errors=errors+1;end
        // Memread + rs hazard
        ex_memread=1;ex_rd=5'd3;id_rs=5'd3;id_rt=5'd0;#5;
        if(stall!==1)begin $display("FAIL rs hazard");errors=errors+1;end
        // Memread + rt hazard
        ex_memread=1;ex_rd=5'd3;id_rs=5'd0;id_rt=5'd3;#5;
        if(stall!==1)begin $display("FAIL rt hazard");errors=errors+1;end
        // Memread + no hazard
        ex_memread=1;ex_rd=5'd3;id_rs=5'd1;id_rt=5'd2;#5;
        if(stall!==0)begin $display("FAIL no hazard");errors=errors+1;end
        if(errors==0) $display("PASS: Hazard Detection test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
