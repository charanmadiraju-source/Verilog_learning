// Binary to Gray Testbench
`timescale 1ns/1ps
module binary_to_gray_tb;
    reg  [3:0] bin;
    wire [3:0] gray;

    binary_to_gray uut (.bin(bin),.gray(gray));

    // Expected Gray code table for 0-15
    reg [3:0] expected [0:15];
    integer i;

    initial begin
        expected[0]=4'b0000; expected[1]=4'b0001; expected[2]=4'b0011; expected[3]=4'b0010;
        expected[4]=4'b0110; expected[5]=4'b0111; expected[6]=4'b0101; expected[7]=4'b0100;
        expected[8]=4'b1100; expected[9]=4'b1101; expected[10]=4'b1111; expected[11]=4'b1110;
        expected[12]=4'b1010; expected[13]=4'b1011; expected[14]=4'b1001; expected[15]=4'b1000;

        $dumpfile("binary_to_gray.vcd");
        $dumpvars(0, binary_to_gray_tb);
        for (i = 0; i < 16; i = i + 1) begin
            bin = i[3:0]; #10;
            if (gray !== expected[i])
                $display("FAIL: bin=%b gray=%b exp=%b", bin, gray, expected[i]);
        end
        $display("Binary to Gray test complete.");
        $finish;
    end
endmodule
