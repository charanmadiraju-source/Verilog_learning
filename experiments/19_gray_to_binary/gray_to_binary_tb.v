// Gray to Binary Testbench
`timescale 1ns/1ps
module gray_to_binary_tb;
    reg  [3:0] gray;
    wire [3:0] bin;

    gray_to_binary uut (.gray(gray),.bin(bin));

    reg [3:0] gray_table [0:15];
    integer i;

    initial begin
        gray_table[0]=4'b0000; gray_table[1]=4'b0001; gray_table[2]=4'b0011; gray_table[3]=4'b0010;
        gray_table[4]=4'b0110; gray_table[5]=4'b0111; gray_table[6]=4'b0101; gray_table[7]=4'b0100;
        gray_table[8]=4'b1100; gray_table[9]=4'b1101; gray_table[10]=4'b1111; gray_table[11]=4'b1110;
        gray_table[12]=4'b1010; gray_table[13]=4'b1011; gray_table[14]=4'b1001; gray_table[15]=4'b1000;

        $dumpfile("gray_to_binary.vcd");
        $dumpvars(0, gray_to_binary_tb);
        for (i = 0; i < 16; i = i + 1) begin
            gray = gray_table[i]; #10;
            if (bin !== i[3:0])
                $display("FAIL: gray=%b bin=%b exp=%0d", gray, bin, i);
        end
        $display("Gray to Binary test complete.");
        $finish;
    end
endmodule
