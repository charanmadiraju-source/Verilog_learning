`timescale 1ns/1ps
module integer_sqrt_tb;
    reg [7:0] radicand; wire [3:0] root;
    integer_sqrt uut(.radicand(radicand),.root(root));
    integer errors=0;
    initial begin
        $dumpfile("integer_sqrt.vcd"); $dumpvars(0,integer_sqrt_tb);
        radicand=8'd0;#5;  if(root!==0)begin $display("FAIL sqrt(0)=%0d",root);errors=errors+1;end
        radicand=8'd4;#5;  if(root!==2)begin $display("FAIL sqrt(4)=%0d",root);errors=errors+1;end
        radicand=8'd9;#5;  if(root!==3)begin $display("FAIL sqrt(9)=%0d",root);errors=errors+1;end
        radicand=8'd16;#5; if(root!==4)begin $display("FAIL sqrt(16)=%0d",root);errors=errors+1;end
        radicand=8'd25;#5; if(root!==5)begin $display("FAIL sqrt(25)=%0d",root);errors=errors+1;end
        radicand=8'd100;#5;if(root!==10)begin $display("FAIL sqrt(100)=%0d",root);errors=errors+1;end
        radicand=8'd15;#5; if(root!==3)begin $display("FAIL sqrt(15)=%0d",root);errors=errors+1;end
        if(errors==0) $display("PASS: Integer Square Root test complete.");
        else $display("FAIL: %0d error(s).",errors);
        $finish;
    end
endmodule
